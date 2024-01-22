as yet unclassified
stopClient

	client ifNotNil:
		[(client respondsTo: #close)
			ifTrue: [client close]
			ifFalse: [client destroy].
		client := nil].
	clientProcess ifNotNil:
		[clientProcess terminate.
		clientProcess := nil].
	inputProcess ifNotNil:
		[inputProcess terminate.
		inputProcess := nil].