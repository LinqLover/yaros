import { YarosServer } from './yaros.js'
import { YarosWebSocketClientConnector, YarosWebSocketServerConnector } from './yaros-connectors.js'

async function main() {
  // Choose one
  const connector = new YarosWebSocketServerConnector(8082)
  //const connector = new YarosWebSocketClientConnector("http://localhost:8082")

  // 1) Start the server
  const server = new YarosServer(connector)
  server.start()

  globalThis.server = server

  return

  // Try this:

  //await connector.waitForClient()
  const smalltalkRemote = await server.remoteObject("Smalltalk")
  console.log(await smalltalkRemote.imageName())

  console.log(await (await (await (await server.remoteObject('Compiler')).evaluate('#(1 2 3)')).collect(x => x * 10)).asJsonString())
}

main().catch(console.error);
