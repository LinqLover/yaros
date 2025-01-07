import { YarosConnector } from './yaros.js'

export class YarosWebSocketConnector extends YarosConnector {
}

export class YarosWebSocketServerConnector extends YarosWebSocketConnector {
  constructor(port) {
    super()
    this.port = port
  }

  start(handler) {
    console.log(`Starting YarosWebSocketServerConnector on port ${this.port} ...`)
    this.sockets = []

	const route = new URLPattern({ pathname: '/comm' })
    this.server = Deno.serve({
      port: this.port,
      handler: (request) => {
		if (!route.exec(request.url)) {
		  return new Response("Not found\n", { status: 404 })
		}
        const upgradeHeader = request.headers.get('upgrade') || ''
        if (upgradeHeader.toLowerCase() !== 'websocket') {
          return new Response("This server only speaks WebSocket.\n", { status: 400 })
        }

        const { socket, response } = Deno.upgradeWebSocket(request)
        socket.onopen = () => {
          console.log("YarosServer: new client connected")
        };
        socket.onmessage = (event) => {
          handler(event.data)
        };
        socket.onclose = () => {
          console.log("YarosServer: client disconnected")
        };
        socket.onerror = (err) => {
          console.error("YarosServer: socket error:", err)
        };
        this.sockets.push(socket)

        return response
      },
    })
  }

  send(data) {
    this.sockets.forEach(socket => {
      socket.send(data)
    })
  }

  async stop() {
    this.sockets.forEach(socket => {
      socket.close()
    })

    await this.server.shutdown()
  }

  async waitForClient() {
    // wait until at least one client is connected
    while (this.sockets.length == 0) {
      await new Promise(resolve => setTimeout(resolve, 100))
    }
  }
}

export class YarosWebSocketClientConnector extends YarosWebSocketConnector {
  constructor(url) {
    super()
    this.url = url
  }

  async start(handler) {
	console.log(`Starting YarosWebSocketClientConnector to ${this.url} ...`)
	this.socket = new WebSocket(`${this.url}/comm`)
	this.socket.onopen = () => {
	  console.log("YarosClient: connected")
	}
	this.socket.onmessage = (event) => {
	  handler(event.data)
	}
	this.socket.onclose = () => {
	  console.log("YarosClient: disconnected")
	}
	this.socket.onerror = (err) => {
	  console.error("YarosClient: socket error:", err)
	}
  }

  send(data) {
	this.socket.send(data)
  }

  stop() {
	this.socket.close()
  }
}
