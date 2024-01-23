control
stopServer

	server ifNotNil:
		[server destroy.
		server := nil].