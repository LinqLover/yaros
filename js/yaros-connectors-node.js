import { YarosConnector } from './yaros.js'
import { WebSocket, WebSocketServer } from 'ws'

export class YarosNodeWebSocketConnector extends YarosConnector {}

// Server-side connector
export class YarosNodeWebSocketServerConnector extends YarosNodeWebSocketConnector {
  constructor(port) {
    super()
    this.port = port
    this.sockets = []
  }

  async start(handler) {
    console.log(`Starting YarosNodeWebSocketServerConnector on port ${this.port} ...`)

    this.wss = new WebSocketServer({ port: this.port, path: '/comm' })

    const listening = new Promise((resolve) => {
      this.wss.on('listening', () => {
        const address = this.wss.address()
        this.port = typeof address === 'object' ? address.port : this.port
        console.log(`YarosNodeWebSocketServerConnector listening on ws://localhost:${this.port}/comm`)
        resolve()
      })
    })

    this.wss.on('connection', (socket) => {
      console.log("YarosServer: new client connected")
      this.sockets.push(socket)

      socket.on('message', (data) => {
        handler(data)
      })

      socket.on('close', () => {
        console.log("YarosServer: client disconnected")
        this.sockets = this.sockets.filter(s => s !== socket)
      })

      socket.on('error', (err) => {
        console.error('YarosServer: socket error:', err)
      })
    })

    this.wss.on('error', (err) => {
      console.error("YarosNodeWebSocketServerConnector error:", err)
    })

    await listening
  }

  send(data) {
    for (const socket of this.sockets) {
      if (socket.readyState === WebSocket.OPEN) {
        socket.send(data)
      }
    }
  }

  stop() {
    // Close all client sockets
    for (const socket of this.sockets) {
      socket.close()
    }
    this.sockets = []

    // Shutdown the server
    return new Promise((resolve, reject) => {
      this.wss.close((err) => {
        if (err) reject(err)
        else resolve()
      })
    })
  }

  async waitForConnection() {
    // wait until at least one client is connected
    while (this.sockets.length === 0) {
      await new Promise(resolve => setTimeout(resolve, 100))
    }
  }
}

// Client-side connector
export class YarosNodeWebSocketClientConnector extends YarosNodeWebSocketConnector {
  constructor(url) {
    super()
    this.url = url
  }

  async start(handler) {
    console.log(`Starting YarosNodeWebSocketClientConnector to ${this.url} ...`)

    this.socket = new WebSocket(`${this.url.replace(/^http/, 'ws')}/comm`)

    const open = new Promise((resolve, reject) => {
      this.socket.on('open', () => {
        console.log("YarosClient: connected")
        resolve()
      })

      this.socket.on('error', (err) => {
        console.error("YarosClient: socket error:", err)
        reject(err)
      })
    })

    this.socket.on('message', (data) => {
      handler(data)
    })

    this.socket.on('close', () => {
      console.log("YarosClient: disconnected")
    })

    await open
  }

  send(data) {
    if (this.socket.readyState === WebSocket.OPEN) {
      this.socket.send(data)
    } else {
      console.warn("YarosClient: cannot send, socket not open")
    }
  }

  stop() {
    if (this.socket) {
      this.socket.close()
    }
  }

  async waitForConnection() {
    while (!this.socket || this.socket.readyState !== WebSocket.OPEN) {
      await new Promise(resolve => setTimeout(resolve, 100))
    }
  }
}
