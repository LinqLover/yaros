// Using an existing REPL with top-level await support is surprisingly tricky, so we vibed our own here.
const stderrEncoder = new TextEncoder();

export function startRepl(context = {}) {
  Object.assign(globalThis, context);

  console.error("Yaros live REPL. Type .help for commands, .exit to leave.");

  return replLoop();
}

async function replLoop() {
  const keyReader = new RawKeyReader();
  const onSigint = () => {
    keyReader.emitInterrupt();
  };

  // Full raw mode ensures Ctrl+C is read as input (0x03) instead of terminating the process.
  Deno.stdin.setRaw(true, { cbreak: false });
  Deno.addSignalListener("SIGINT", onSigint);
  keyReader.start();

  try {
    while (true) {
      const inputResult = await readLine("yaros> ", keyReader);

      if (inputResult.type === "eof") {
        console.error("Leaving REPL.");
        return;
      }

      if (inputResult.type === "interrupt") {
        continue;
      }

      const input = inputResult.line;
      const trimmedInput = input.trim();

      if (trimmedInput === ".exit") {
        console.error("Leaving REPL.");
        return;
      }

      if (trimmedInput === ".help") {
        printHelp();
        continue;
      }

      if (!trimmedInput) {
        continue;
      }

      try {
        const explicitAwait = /^\s*await\b/.test(input);
        const result = evaluateReplInput(input);

        if (explicitAwait && isPromiseLike(result)) {
          const awaitedResult = await awaitWithInterrupt(result, keyReader);
          if (awaitedResult !== undefined) {
            print(awaitedResult);
          }
        } else if (result !== undefined) {
          print(result);
        }
      } catch (error) {
        if (error instanceof ReplInterruptedError) {
          console.error("^C");
          continue;
        }
        console.error(error?.stack ?? error);
      }
    }
  } finally {
    keyReader.stop();
    Deno.removeSignalListener("SIGINT", onSigint);
    Deno.stdin.setRaw(false);
  }
}

function printHelp() {
  console.error(`Commands:
  .help  Show this help message
  .exit  Leave the REPL

Keys:
  Up/Down  Browse command history
  Ctrl+C   Cancel the current input or await
  Ctrl+D   Exit on an empty prompt
`);
}

function evaluateReplInput(input) {
  const code = input.trim();

  if (/^await\b/.test(code)) {
    return eval(`(async () => { return ${code}; })()`);
  }

  try {
    return eval(`(${code})`);
  } catch (_expressionError) {
    return eval(code);
  }
}

function isPromiseLike(value) {
  return value != null && typeof value.then === "function";
}

function print(value) {
  console.error(Deno.inspect(value, {
    colors: true,
    depth: 6,
    iterableLimit: 100,
    strAbbreviateSize: 300,
  }));
}

class ReplInterruptedError extends Error {
  constructor() {
    super("REPL evaluation interrupted");
    this.name = "ReplInterruptedError";
  }
}

async function awaitWithInterrupt(value, keyReader) {
  const promise = Promise.resolve(value);
  keyReader.clearPendingKeys();

  let unregisterInterrupt = null;
  const interruptPromise = new Promise((_, reject) => {
    unregisterInterrupt = keyReader.onInterrupt(() => {
      reject(new ReplInterruptedError());
    });
  });

  try {
    return await Promise.race([promise, interruptPromise]);
  } finally {
    unregisterInterrupt?.();
  }
}

async function readLine(promptText, keyReader) {
  let line = "";
  let historyIndex = null;

  await writeToStderr(`${promptText}`);

  while (true) {
    const token = await keyReader.nextKey();

    if (token.type === "eof") {
      await writeToStderr("\n");
      return { type: "eof" };
    }

    if (token.type === "interrupt") {
      await writeToStderr("^C\n");
      return { type: "interrupt" };
    }

    if (token.type === "enter") {
      await writeToStderr("\n");
      const trimmed = line.trim();
      if (trimmed) {
        keyReader.pushHistory(line);
      }
      return { type: "line", line };
    }

    if (token.type === "backspace") {
      if (line.length > 0) {
        line = line.slice(0, -1);
        await redrawLine(promptText, line);
      }
      continue;
    }

    if (token.type === "ctrl-d") {
      if (line.length === 0) {
        await writeToStderr("\n");
        return { type: "eof" };
      }
      continue;
    }

    if (token.type === "up") {
      if (keyReader.history.length === 0) {
        continue;
      }
      historyIndex = historyIndex === null
        ? keyReader.history.length - 1
        : Math.max(0, historyIndex - 1);
      line = keyReader.history[historyIndex];
      await redrawLine(promptText, line);
      continue;
    }

    if (token.type === "down") {
      if (historyIndex === null) {
        continue;
      }
      if (historyIndex < keyReader.history.length - 1) {
        historyIndex += 1;
        line = keyReader.history[historyIndex];
      } else {
        historyIndex = null;
        line = "";
      }
      await redrawLine(promptText, line);
      continue;
    }

    if (token.type === "char") {
      line += token.value;
      await writeToStderr(token.value);
    }
  }
}

async function redrawLine(promptText, line) {
  await writeToStderr(`\r${promptText}${line}\x1b[K`);
}

async function writeToStderr(text) {
  await Deno.stderr.write(stderrEncoder.encode(text));
}

class RawKeyReader {
  constructor() {
    this.pendingKeys = [];
    this.keyWaiters = [];
    this.interruptListeners = new Set();
    this.running = false;
    this.history = [];
    this.#escapeState = 0;
  }

  #escapeState;

  start() {
    if (this.running) {
      return;
    }
    this.running = true;
    this.#pump().catch(error => {
      this.#emitKey({ type: "eof" });
      console.error(error?.stack ?? error);
    });
  }

  stop() {
    this.running = false;
  }

  async nextKey() {
    if (this.pendingKeys.length > 0) {
      return this.pendingKeys.shift();
    }

    return await new Promise(resolve => {
      this.keyWaiters.push(resolve);
    });
  }

  onInterrupt(listener) {
    this.interruptListeners.add(listener);
    return () => this.interruptListeners.delete(listener);
  }

  clearPendingKeys() {
    this.pendingKeys = [];
  }

  emitInterrupt() {
    this.#emitKey({ type: "interrupt" });
  }

  pushHistory(line) {
    if (!line.trim()) {
      return;
    }
    if (this.history[this.history.length - 1] !== line) {
      this.history.push(line);
    }
    if (this.history.length > 500) {
      this.history.shift();
    }
  }

  #emitKey(key) {
    if (key.type === "interrupt") {
      for (const listener of this.interruptListeners) {
        listener();
      }
    }

    if (this.keyWaiters.length > 0) {
      const resolve = this.keyWaiters.shift();
      resolve(key);
      return;
    }
    this.pendingKeys.push(key);
  }

  async #pump() {
    const buffer = new Uint8Array(64);

    while (this.running) {
      const bytesRead = await Deno.stdin.read(buffer);
      if (bytesRead === null) {
        this.#emitKey({ type: "eof" });
        return;
      }

      for (let i = 0; i < bytesRead; i += 1) {
        this.#consumeByte(buffer[i]);
      }
    }
  }

  #consumeByte(byte) {
    if (this.#escapeState === 0) {
      if (byte === 0x1b) {
        this.#escapeState = 1;
        return;
      }

      if (byte === 0x03) {
        this.#emitKey({ type: "interrupt" });
        return;
      }

      if (byte === 0x04) {
        this.#emitKey({ type: "ctrl-d" });
        return;
      }

      if (byte === 0x0d || byte === 0x0a) {
        this.#emitKey({ type: "enter" });
        return;
      }

      if (byte === 0x08 || byte === 0x7f) {
        this.#emitKey({ type: "backspace" });
        return;
      }

      if (byte >= 0x20) {
        this.#emitKey({ type: "char", value: String.fromCharCode(byte) });
      }
      return;
    }

    if (this.#escapeState === 1) {
      this.#escapeState = byte === 0x5b ? 2 : 0;
      return;
    }

    if (this.#escapeState === 2) {
      if (byte === 0x41) {
        this.#emitKey({ type: "up" });
      } else if (byte === 0x42) {
        this.#emitKey({ type: "down" });
      }
      this.#escapeState = 0;
    }
  }
}
