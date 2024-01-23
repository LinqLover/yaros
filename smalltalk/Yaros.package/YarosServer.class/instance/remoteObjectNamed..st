public
remoteObjectNamed: aString

	| id result |
	id := self sendLookup: aString.
	result := (queues at: id put: SharedQueue new) next.
	self flag: #todo. "thread-safe!"
	queues removeKey: id.
	^ result