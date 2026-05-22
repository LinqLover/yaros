import { YarosServer } from './yaros.js'
import {
  YarosNodeWebSocketServerConnector,
  YarosNodeWebSocketClientConnector
} from './yaros-connectors-node.js'
import { startRepl } from './helpers/repl-node.js'

import yargs from 'yargs/yargs'
import { hideBin } from 'yargs/helpers'

async function main() {
  const parser = yargs(hideBin(process.argv))
    .scriptName('yaros')
    // Ensure root parser has the shared options so defaults apply when no command is given
    .option('port', {
      type: 'number',
      default: 8092,
      describe: "Port to listen on or connect to"
    })
    .command('server', "Use the WebSocket server connector (default)")
    .command('client', "Use the WebSocket client connector", parser => parser
      .option('host', {
        type: 'string',
        default: 'localhost',
        describe: "Host to connect to in client mode"
      }))
    .option('interactive', {
      type: 'boolean',
      default: false,
      describe: "Start a REPL after the server starts"
    })
    .help()
    .check((args) => {
      const [command = 'server', ...extraPositionals] = args._
      console.log("Parsed command:", { command, extraPositionals, args })

      if (extraPositionals.length > 0) {
        throw new Error(`Unexpected positional arguments: ${extraPositionals.join(', ')}`)
      }
      if (command !== 'server' && command !== 'client') {
        throw new Error(`Unknown command: ${command}`)
      }
      if (command === 'server' && args.host && args.host !== 'localhost') {
        throw new Error("Option --host is not applicable in server mode")
      }
      return true
    })
    .strict()
    .version(false)

  const argv = parser.parseSync()
  const [command = 'server'] = argv._

  const useClientConnector = command === 'client'
  const connector = useClientConnector
    ? new YarosNodeWebSocketClientConnector(`http://${argv.host}:${argv.port}`)
    : new YarosNodeWebSocketServerConnector(argv.port)

  // 1) Start the server
  const server = new YarosServer(connector)
  global.yaros = server
  await server.start()
  await connector.waitForConnection()

  if (argv.interactive) {
    await startRepl({ yaros: server, server })
  }
}

main().catch((err) => {
  console.error(err)
  process.exit(1)
})
