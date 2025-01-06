public
remoteObjectNamed: aString

	| message queue answer |
	serverRunning ifFalse: [self error: 'server not running'].
	
	message := self newLookupMessageFor: aString.
	queue := queues at: message id put: SharedQueue new.
	self send: message.
	
	answer := [queue next]
		valueWithin: 5 seconds onTimeout: [self error: 'timeout'].
	self flag: #todo. "thread-safe!"
	queues removeKey: message id.
	
	^ answer result