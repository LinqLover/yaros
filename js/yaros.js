// Providing example modules for evals
/* import tiktoken from 'npm:tiktoken'
import gptTokenizer from 'npm:gpt-tokenizer/model/gpt-4o'

globalThis.tiktoken = tiktoken
globalThis.gptTokenizer = gptTokenizer */

/**
 * TODOS: ugly prototype by ChatGPT. Refactor. Be more systematical about proxy resolution, smalltalk protocol, string conversion (util?), and many other things.
 */


export class YarosServer {
  //#region Public API
  constructor(connector) {
    this.connector = connector
  }

  environment = globalThis

  /**
   * Minimal Yaros-like WebSocket server in Deno. Listens on the given port,
   * upgrades requests to WebSockets, and handles:
   *   - "lookup" -> find object in globalThis
   *   - "messageSend" -> call method on that object
   */
  start() {
    return this.connector.start(data => {
      let msg
      try {
        msg = JSON.parse(data)
      } catch (err) {
        console.error("Cannot parse JSON:", data, err)
        return
      }
      this.handleMessage(msg)
    })
  }

  /**
   * Returns a JavaScript Proxy object that will “pretend” to be the remote object
   * identified by `remoteName`.
   *
   * Example usage:
   *   const smalltalk = await client.remoteObjectProxy("Smalltalk")
   *   const answer = await smalltalk.imageName()
   */
  async remoteObject(remoteName) {
    if (typeof remoteName === 'string') {
      remoteName = Symbol(remoteName)
    }
    return await this.sendMessage({
      type: 'lookup',
      name: this._asYarosJsonObject(remoteName),
    })
  }

  /**
   * Send a message (with .type, .id, etc.) to the other side,
   * returning a Promise that resolves with the server’s “answer” result.
   * Meanwhile, we remain responsive to other incoming messages
   * (including nested calls).
   */
  sendMessage(message) {
    if (!message.id) {
      // pseudo-unique ID
      message.id = `m-${this._makeId()}`
    }
    const messageId = message.id

    const promise = new Promise((resolve, reject) => {
      this._pendingRequests.set(messageId, { resolve, reject });
    });
    this.connector.send(JSON.stringify(message));
    return promise;
  }
  //#endregion Public API

  //#region Object management
  /** Maps an ID (string) -> actual object */
  _sharedObjects = new Map()
  /** Maps an actual object -> its assigned ID */
  _sharedObjectIds = new Map()
  /** Maps an ID -> remote object proxy */
  _remoteObjects = new Map()

  /**
   * For storing promises waiting for an answer
   * messageID -> {resolve, reject}
   */
  _pendingRequests = new Map();

  _makeId() {
    return crypto.randomUUID?.() || Math.random().toString(36).slice(2)
  }

  /**
   * Return an existing ID for 'obj' if we have it; otherwise create a new ID, store in both tables.
   */
  _getOrMakeIdFor(obj) {
    if (obj === null || obj === undefined) return null
    if (typeof obj !== 'object' && typeof obj !== 'function') {
      return null
    }

    const existingId = this._sharedObjectIds.get(obj);
    if (existingId) {
      return existingId;
    }

    const newId = `o-${this._makeId()}`
    this._sharedObjectIds.set(obj, newId);
    this._sharedObjects.set(newId, obj);
    return newId;
  }

  /**
   * Convert a JS value into JSON:
   *   - If it's a primitive => just return it as-is
   *   - Otherwise => return { id: "someId" }
   */
  _asYarosJsonObject(value) {
    if (value === null || value === undefined) return null;
    const t = typeof value;
    if (t === 'string' || t === 'number' || t === 'boolean') {
      return value // primitive
    }
    if (t === 'symbol') {
      return { symbol: value.description }
    }
    
    if (value.proxyToken) {
      return { remoteId: value.yarosId }
    }
  
    const id = this._getOrMakeIdFor(value);
    if (id == null) {
      console.error("is this ever called???")
      // It's an object but we can't get an ID for some reason.
      // For safety, convert it to a string or something minimal.
      return "(un-serializable)"
    }
    return { id }
  }

  /**
   * Convert a JSON object back into a JS value:
   *   - If it's a primitive => return it
   *   - If it's { id: "..." } => look up in objectTable
   */
  _objectFromJson(yarosValue) {
    if (yarosValue === null || yarosValue === undefined) return yarosValue;
    if (typeof yarosValue !== 'object') {
      // primitive
      return yarosValue
    }

    if ('symbol' in yarosValue) {
      return Symbol.for(yarosValue.symbol);
    }

    if ('remoteId' in yarosValue) {
      return this._sharedObjects.get(yarosValue.remoteId)
    }

    if (!('id' in yarosValue)) {
      // plain object
      return yarosValue
    }

    const id = yarosValue.id
    // create proxy
    if (!this._remoteObjects.has(id)) {
      this._remoteObjects.set(id, this._makeProxy(id))
    }
    return this._remoteObjects.get(yarosValue.id)
  }

  _makeProxy(id) {
    const server = this
    return new Proxy({}, {
      get(_target, propKey) {
        if (propKey === 'proxyToken') {
          return this;
        }
        if (propKey === 'yarosId') {
          return id;
        }
        if (propKey === 'then') {
          return undefined;
        }
        if (propKey === Symbol.for('debug.description')) {
          return function () {
            return `Proxy(${id})`
          }
        }

        return async function (...args) {
          let selector = propKey.toString().replace(/_/g, ':')
          if (args.length > 0) {
            selector += ':'
          }
          const message = {
            type: 'messageSend',
            receiver: { remoteId: id },
            selector: selector,
            arguments: args.map(server._asYarosJsonObject.bind(server)),
          }
          return await server.sendMessage(message)
        }
      }
    })
  }
  //#endregion Object management

  //#region Message handling
  _messageHandlers = {
    lookup: (message) => {
      let name = this._objectFromJson(message.name);
      if (typeof name === 'symbol') {
        name = name.description
      }
      const targetObj = this.environment[name]

      return this.sendAnswer(message, {
        result: this._asYarosJsonObject(targetObj),
      })
    },

    messageSend: async (message) => {
      try {
        const receiverObj = this._objectFromJson(message.receiver)
        if (!receiverObj) {
          throw new Error("Receiver not found or is null")
        }

        let realArgs = (message.arguments || []).map(arg => this._objectFromJson(arg))

        // The method or property is msg.selector (e.g. "log:with:" -> "log" (first part))
        const selector = message.selector
        const methodName = selector.split(':')[0]
        let property = receiverObj[methodName]

        if (typeof property === 'function') { // evaluate function
          // resolve proxies if necessary
          if (property === Function.prototype.apply) {
            if (realArgs.length > 1) {
              if (realArgs[1].proxyToken) {
                realArgs[1] = await this._resolveProxyArray(realArgs[1])
              }
            }
          } else if (property === console.log) {
            realArgs = await Promise.all(realArgs.map(arg => {
              if (arg.proxyToken) {
                return arg.printString()
              }
              return arg
            }))
          } else if ([Array.prototype.forEach, Array.prototype.map].includes(property)) {
            if (realArgs.length > 0) {
              const fn = property;
              property = (..._realArgs) => {
                const block = _realArgs[0]
                return Promise.all(fn.apply(receiverObj, [
                  block.proxyToken !== undefined ? (...args) => block.valueWithEnoughArguments(args) : block,
                  ..._realArgs.slice(1)
                ]))
              }
            }
          }

          const resultVal = await property.apply(receiverObj, realArgs)
          // TODO: refactor - always await?
          if (!(resultVal instanceof Promise)) {
            // Synchronous result
            return this.sendAnswer(message, {
              result: this._asYarosJsonObject(resultVal),
              error: null,
            })
          }

          resultVal.then((val) => {
            return this.sendAnswer(message, {
              result: this._asYarosJsonObject(val),
            })
          }).catch((err) => {
            return this.sendAnswer(message, {
              result: undefined,
              error: err.message,
            })
          })
        }

        if (typeof property !== 'undefined') { // get property
          return this.sendAnswer(message, {
            result: this._asYarosJsonObject(property),
            error: null,
          })
        }

        // operator?
        const operators = {
          '==': (a, b) => a == b,
          '===': (a, b) => a === b,
          '!=': (a, b) => a != b,
          '!==': (a, b) => a !== b,
          '>': (a, b) => a > b,
          '<': (a, b) => a < b,
          '>=': (a, b) => a >= b,
          '<=': (a, b) => a <= b,
        }
        if (selector in operators) {
          const resultVal = operators[selector](realArgs[0], realArgs[1])
          return this.sendAnswer(message, {
            result: this._asYarosJsonObject(resultVal),
            error: null,
          })
        }

        // minimal smalltalk protocol
        const smalltalkFns = {
          '=': (a, b) => a === b,
          'in:': (block) => {
            return this._resolveProxyFunction(block)(receiverObj)
          },
          isInteger: () => {
            return Number.isInteger(receiverObj)
          },
          isPromise: () => {
            return receiverObj instanceof Promise
          },
          'respondsTo:': (selector) => {
            return receiverObj[selector] !== undefined
          },
          printString: () => {
            if (Array.isArray(receiverObj)) {
              return `[${(receiverObj.map(x => x.proxyToken !== undefined ? x.printString() : x))}]`
            }
            try {
              return `${receiverObj}`
            } catch (_) {
              // e.g., modules
              return `(${Object.prototype.toString(receiverObj)})`
            }
          },
          'printOn:': async (stream) => {
            return stream.nextPutAll((receiverObj?.printString ? await receiverObj.printString() : smalltalkFns.printString(receiverObj)))
          },
          resolveProxyArray: () => {
            return receiverObj
          },
          'value:': (arg) => {
            return this._resolveProxyFunction(receiverObj)(arg)
          }
        }
        if (typeof receiverObj === 'function') {
          Object.assign(smalltalkFns, {
            value: () => {
              return receiverObj()
            },
            'value:': (arg) => {
              return receiverObj(arg)
            },
            'value:value:': (arg1, arg2) => {
              return receiverObj(arg1, arg2)
            },
          })
        }
        if (Array.isArray(receiverObj)) {
          Object.assign(smalltalkFns, {
            size: () => {
              return receiverObj.length
            },
            'at:': (index) => {
              return receiverObj[index - 1]
            },
            'do:': (block) => {
              receiverObj.forEach(x => block.value(x))
            },
          })
        }
        if (receiverObj.prototype !== undefined) {
          Object.assign(smalltalkFns, {
            'new': () => {
              return new receiverObj()
            },
          })
        }
        if (receiverObj === Object.prototype) {
          Object.assign(smalltalkFns, {
            'new': () => {
              return {}
            },
          })
        }
        const smalltalkFn = smalltalkFns[selector]
        if (smalltalkFn) {
          const resultVal = await smalltalkFn.apply(receiverObj, realArgs)
          return this.sendAnswer(message, {
            result: this._asYarosJsonObject(resultVal),
            error: null,
          })
        }

        let receiverObjDescription
        try {
          receiverObjDescription = `${receiverObj}`
        } catch (_) {
          receiverObjDescription = `(${Object.prototype.toString(receiverObj)})`
        }
        throw new Error(`${receiverObjDescription}.${methodName} is not a function or property`)
      } catch (err) {
        err.description = err.message
        this.sendAnswer(message, {
          result: undefined,
          error: this._asYarosJsonObject({
            first: err,
            second: err.currentStack ?? err.stack,
          }),
        })
      }
    },

    answer: async (message) => {
      const pending = this._pendingRequests.get(message.id);
      if (pending) {
        this._pendingRequests.delete(message.id);
        if (!message.error) {
          pending.resolve(this._objectFromJson(message.result))
          return
        }

        const exception = this._objectFromJson(message.error);
        const error = new YarosError(await exception.first(), await exception.second());
        try {
          error.message = `${await error.exception.printString()}`
        } catch (e) {
          error.message = `${error.exception}, printString failed: ${e}`
        }
        try {
          const jsStack = error.stack.split('\n')
          error.currentStack = (await this._resolveProxyArray(await error.callStack)).concat(jsStack.slice(1))
          error.stack = jsStack[0] + '\n' + (await Promise.all(await this._resolveProxyArray(await error.callStack.collect(async context => `    ${context?.proxyToken !== undefined ? await context.printString() : context}`)))).join('\n') + '\n' + jsStack.slice(1).join('\n')
        } catch (e) {
          error.stack = `${error.exception}, stack failed: ${e})\n${error.stack}`
        }
        pending.reject(error)
      } else {
        console.warn("Received an answer without a matching request:", message);
      }
    }
  }

  /**
   * handleIncomingMessage(msg)
   *
   * Dispatch based on msg.type. The main ones:
   *   - "lookup": find object in the environment and respond with an ID
   *   - "messageSend": call a method on the object
   *   - "answer": typically just log (server won't do much with it)
   */
  async handleMessage(message) {
    const messageHandler = this._messageHandlers[message.type]

    if (!messageHandler) {
      console.warn("Unknown message type:", message)
      return
    }

    return await messageHandler(message)
  }

  async _resolveProxyArray(array) {
    return await Promise.all(Array.from({ length: await array.size() }, (_, i) => array.at(i + 1)));
  }

  _resolveProxyFunction(fn) {
    return fn.proxyToken !== undefined
      ? (obj) => fn.value(obj)
      : fn
  }

  /**
   * sendAnswer(originalMsg, { result, error })
   *
   * Helper to produce a "type:answer" message responding to originalMsg.id
   */
  sendAnswer(originalMessage, { result, error }) {
    const answer = {
      id: originalMessage.id,
      type: 'answer',
      result: error ? undefined : result,
      error: error || null,
    }
    this.connector.send(JSON.stringify(answer))
  }
  //#endregion Message handling
}

export class YarosError extends Error {
  constructor(remoteException, callStack) {
    super()
    /** A remote exception. */
    this.exception = remoteException
    this.callStack = callStack
  }
}

export class YarosConnector {
}
