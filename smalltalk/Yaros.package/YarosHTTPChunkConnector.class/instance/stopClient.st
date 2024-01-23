control
stopClient

	client ifNotNil:
		[client destroy.
		client := nil].
	clientProcess ifNotNil:
		[clientProcess terminate.
		clientProcess := nil].