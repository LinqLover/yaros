control
stopClient

	webServer ifNotNil:
		[webServer destroy.
		webServer := nil].
	mutex := nil.
	sockets := nil.