# yaros.js

## CLI

### [Deno](https://deno.land/)

```bash
deno install
deno task test
deno run start server [--port 8092] [--interactive]
deno run start client [--server localhost] [--port 8092] [--interactive]
deno run start --help
```

### node

```bash
npm install
npm test
npm run start:node -- server [--port 8092] [--interactive]
npm run start:node -- client [--server localhost] [--port 8092] [--interactive]
npm run start:node -- --help
```

## API

```js
import { YarosServer } from './yaros.js'
import { YarosWebSocketServerConnector, YarosWebSocketClientConnector } from './yaros-connectors.js'

const server = new YarosServer(
  // choose one
  new YarosWebSocketServerConnector(8092),
  new YarosWebSocketClientConnector('ws://localhost:8082')
)
await server.start()
await server.connector.waitForConnection()

const remoteConsole = await server.remoteObject('console')
await remoteConsole.log("Hello to the other side!")
console.log(await remoteConsole.toString())
```
