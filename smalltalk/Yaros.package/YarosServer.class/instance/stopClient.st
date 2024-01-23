control
stopClient

	self connector stopClient.
	
	inputProcess ifNotNil:
		[inputProcess terminate.
		inputProcess := nil].