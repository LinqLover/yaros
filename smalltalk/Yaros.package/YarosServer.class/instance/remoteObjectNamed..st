public
remoteObjectNamed: aString

	| message answer |
	message := self sendLookup: aString.
	answer := (queues at: message id put: SharedQueue new) next.
	self flag: #todo. "thread-safe!"
	queues removeKey: message id.
	^ answer result