public
evaluate: aMessageSend

	| id errorAndResult |
	id := self sendMessageSend: aMessageSend.
	errorAndResult := [(queues at: id put: SharedQueue new) next]
		valueWithin: 5 seconds onTimeout: [self error: 'timeout'].
	self flag: #todo. "thread-safe!"
	self flag: #bug. "must create queue prior to sending!"
	queues removeKey: id.
	errorAndResult first ifNotNil: [:errorAndStack |
		^ YarosRemoteError signalFor: errorAndStack first stack: errorAndStack second].
	^ errorAndResult second