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
}

main().catch(console.error);
