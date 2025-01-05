public
evaluate: aMessageSend

	| message answer |
	message := self sendMessageSend: aMessageSend.
	answer := [(queues at: message id put: SharedQueue new) next]
		valueWithin: 5 seconds onTimeout: [self error: 'timeout'].
	self flag: #todo. "thread-safe!"
	self flag: #bug. "must create queue prior to sending!"
	queues removeKey: message id.
	answer exception ifNotNil: [:errorAndStack |
		^ YarosRemoteError signalFor: errorAndStack first stack: errorAndStack second].
	^ answer result