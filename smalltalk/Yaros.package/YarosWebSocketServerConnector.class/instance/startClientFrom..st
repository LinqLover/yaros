control
startClientFrom: inputStream

	webServer := WebServer new.
	mutex := Mutex new.
	sockets := OrderedCollection new.
	webServer
		addService: '/comm'
		action: [:request | self runWebSocketFor: request from: inputStream].
	webServer listenOn: self clientPort.