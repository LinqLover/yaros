import repl from 'node:repl';

export function startRepl(context = {}) {
  Object.assign(globalThis, context);

  console.error("Yaros live REPL. Type .help for commands, .exit to leave.");

  const replServer = repl.start({
    prompt: 'yaros> ',
    useGlobal: true,
    useColors: true,
    ignoreUndefined: true,
  });

  Object.assign(replServer.context, context);

  return new Promise(resolve => {
    replServer.once('exit', () => {
      console.error('Leaving REPL.');
      resolve();
    });
  });
}
