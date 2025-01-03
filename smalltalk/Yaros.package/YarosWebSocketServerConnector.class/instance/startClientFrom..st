control
startClientFrom: inputStream

	webServer := WebServer new.
	mutex := Mutex new.
	sockets := OrderedCollection new.
	webServer
		addService: '/comm'
		action: [:req |
			| socket |
			socket := req asWebSocket.
			socket timeout: 5 minutes asSeconds.
			socket onMessage: [:data |
				inputStream nextPut: data].
			socket onClose:
				[mutex critical: [sockets remove: socket]].
			mutex critical: [sockets add: socket].
			socket run].
	webServer listenOn: self clientPort.