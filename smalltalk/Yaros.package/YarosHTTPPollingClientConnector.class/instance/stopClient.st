control
stopClient

	clientProcess ifNotNil:
		[clientProcess terminate.
		clientProcess := nil].