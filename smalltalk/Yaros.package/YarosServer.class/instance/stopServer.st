as yet unclassified
stopServer

	server ifNotNil:
		[server destroy.
		server := nil].
	serverProcess ifNotNil:
		[serverProcess terminate.
		serverProcess := nil].