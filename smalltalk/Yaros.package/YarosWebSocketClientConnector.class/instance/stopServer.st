control
stopServer

	serverProcess ifNotNil:
		[serverProcess terminate.
		serverProcess := nil].