control
stopClient

	self connector removeActionsWithReceiver: self forEvent: #clientStopped.
	self connector stopClient.
	
	inputProcess ifNotNil:
		[inputProcess terminate.
		inputProcess := nil].