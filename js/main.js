import { YarosServer } from './yaros.js'
import { YarosWebSocketClientConnector, YarosWebSocketServerConnector } from './yaros-connectors.js'
import { parseArgs } from "@std/cli/parse-args";
import { startRepl } from './helpers/repl.js'

function printUsage() {
  console.log(`Usage:
  deno run --allow-net main.js [server|client] [options]

Options:
  --port <port>         Port to listen on or connect to (default: 8092)
  --host <host>         Host to connect to in client mode (default: localhost)
  --interactive         Start a REPL after the server starts
  --help                Show this help message

Positional commands:
  server                Use the WebSocket server connector (default)
  client                Use the WebSocket client connector
`)
}

async function main() {
  const flags = parseArgs(Deno.args, {
    string: ['port', 'host'],
    boolean: ['interactive', 'help'],
    default: {
      port: 8092,
      host: 'localhost',
      interactive: false,
      help: false,
    },
  })

  if (flags.help) {
    printUsage()
    return
  }

  const [command = 'server', ...extraPositionals] = flags._

  if (extraPositionals.length > 0) {
    throw new Error(`Unexpected positional arguments: ${extraPositionals.join(', ')}`)
  }
  if (command !== 'server' && command !== 'client') {
    throw new Error(`Unknown command: ${command}`)
  }
  if (command === 'server' && flags.host !== 'localhost') {
    throw new Error("Option --host is not applicable when using server mode")
  }

  const useClientConnector = command === 'client'
  const connector = useClientConnector
    ? new YarosWebSocketClientConnector(`http://${flags.host}:${flags.port}`)
    : new YarosWebSocketServerConnector(flags.port)

  // 1) Start the server
  const server = new YarosServer(connector)
  globalThis.yaros = server
  await server.start()
  await connector.waitForConnection()

  if (flags.interactive) {
    await startRepl()
  }

  return

  // Try this:

  //await connector.waitForClient()
  const smalltalkRemote = await server.remoteObject("Smalltalk")
  console.log(await smalltalkRemote.imageName())

  console.log(await (await (await (await server.remoteObject('Compiler')).evaluate('#(1 2 3)')).collect(x => x * 10)).asJsonString())
}

main().catch(console.error);
