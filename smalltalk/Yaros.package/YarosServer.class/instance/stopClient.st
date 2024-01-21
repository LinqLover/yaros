as yet unclassified
stopClient

	client ifNotNil:
		[client close.
		client := nil].
	clientProcess ifNotNil:
		[clientProcess terminate.
		clientProcess := nil].
	inputProcess ifNotNil:
		[inputProcess terminate.
		inputProcess := nil].