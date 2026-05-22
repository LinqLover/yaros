import test from 'node:test'
import assert from 'node:assert/strict'

import { YarosServer } from '../yaros.js'

const connectors = typeof Deno !== 'undefined'
  ? await (async () => {
    const { YarosWebSocketServerConnector, YarosWebSocketClientConnector } = await import('../yaros-connectors.js')
    return {
      serverConnector: YarosWebSocketServerConnector,
      clientConnector: YarosWebSocketClientConnector,
    }
  })()
  : await (async () => {
    const nodeConnectorModule = '../yaros-connectors-node.js' // no inline import to avoid type errors in Deno
    const { YarosNodeWebSocketServerConnector, YarosNodeWebSocketClientConnector } = await import(nodeConnectorModule)
    return {
      serverConnector: YarosNodeWebSocketServerConnector,
      clientConnector: YarosNodeWebSocketClientConnector,
    }
  })()

async function createBridge() {
  const serverConnector = new connectors.serverConnector(0)
  const server = new YarosServer(serverConnector)
  server.environment = {
    serverAPI: {
      location: 'server',
      echo(value) {
        return `server:${value}`
      },
      callClient(callback) {
        return callback.echo('from-server')
      },
    },
  }
  await server.start()

  const clientConnector = new connectors.clientConnector(`http://localhost:${serverConnector.port}`)
  const client = new YarosServer(clientConnector)
  client.environment = {
    clientAPI: {
      location: 'client',
      echo(value) {
        return `client:${value}`
      },
      callServer(callback) {
        return callback.echo('from-client')
      },
    },
  }
  await client.start()

  await clientConnector.waitForConnection()
  await serverConnector.waitForConnection()

  return {
    server,
    client,
  }
}

async function withBridge(run) {
  const bridge = await createBridge()
  try {
    await run(bridge)
  } finally {
    await Promise.allSettled([
      bridge.client.stop(),
      bridge.server.stop(),
    ])
  }
}

test("property access", async (t) => {
  await t.test("server can access client property", async () => {
    await withBridge(async ({ server }) => {
      const serverApi = await server.remoteObject('clientAPI')
      assert.strictEqual(await serverApi.location(), 'client', "server can access client property")
    })
  })
  
  await t.test("client can access server property", async () => {
    await withBridge(async ({ client }) => {
      const clientApi = await client.remoteObject('serverAPI')
      assert.strictEqual(await clientApi.location(), 'server', "client can access server property")
    })
  })
})

test("method calls", async (t) => {
  await t.test("server can call client method", async () => {
    await withBridge(async ({ server }) => {
      const serverApi = await server.remoteObject('clientAPI')
      assert.strictEqual(await serverApi.echo('hello'), 'client:hello', "server can call client method")
    })
  })

  await t.test("client can call server method", async () => {
    await withBridge(async ({ client }) => {
      const clientApi = await client.remoteObject('serverAPI')
      assert.strictEqual(await clientApi.echo('world'), 'server:world', "client can call server method")
    })
  })
})

test("callbacks", async (t) => {
  await t.test("callback from client to server", async () => {
    await withBridge(async ({ server, client }) => {
      const serverApi = await server.remoteObject('clientAPI')

      const result = await serverApi.callServer({
        echo(value) {
          return `server-callback:${value}`
        },
      })
      assert.strictEqual(result, 'server-callback:from-client', "client -> server callback")
      const clientApi = await client.remoteObject('serverAPI')
      assert.strictEqual(await clientApi.echo('still-open'), 'server:still-open', "connection still open")
    })
  })

  await t.test("callback from server to client", async () => {
    await withBridge(async ({ server, client }) => {
      const clientApi = await client.remoteObject('serverAPI')

      const result = await clientApi.callClient({
        echo(value) {
          return `client-callback:${value}`
        },
      })
      assert.strictEqual(result, 'client-callback:from-server', "server -> client callback")
      const serverApi = await server.remoteObject('clientAPI')
      assert.strictEqual(await serverApi.echo('still-open'), 'client:still-open', "connection still open")
    })
  })
})

test("errors do not break the connection", async () => {
  await withBridge(async ({ server, client }) => {
    const serverApi = await server.remoteObject('clientAPI')

    await assert.rejects(serverApi.missingMethod())
    // TODO: remoteObject should return undefined
    assert.strictEqual(await server.remoteObject('absentRemoteObject'), null, "missing remote object should return null")

    assert.strictEqual(await serverApi.echo('after-error'), 'client:after-error', "connection stable after error")
    const clientApi = await client.remoteObject('serverAPI')
    assert.strictEqual(await clientApi.echo('after-error'), 'server:after-error', "connection stable in other direction")
  })
})
