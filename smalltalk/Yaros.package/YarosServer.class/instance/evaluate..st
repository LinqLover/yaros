public
evaluate: aMessageSend

	| queue message answer |
	self isRunning ifFalse: [self error: 'server not running'].
	
	message := self newMessageSendMessageFor: aMessageSend.
	queue := queues at: message id put: SharedQueue new.
	self send: message.
	
	answer := [queue next]
		valueWithin: 5 seconds onTimeout: [self error: 'timeout'].
	self flag: #todo. "thread-safe!"
	queues removeKey: message id.
	
	answer exception ifNotNil: [:errorAndStack |
		^ YarosRemoteError signalFor: errorAndStack first stack: errorAndStack second].
	^ answer result