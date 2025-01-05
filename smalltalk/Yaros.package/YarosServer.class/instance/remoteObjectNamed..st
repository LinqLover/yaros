public
remoteObjectNamed: aString

	| id errorAndResult |
	id := self sendLookup: aString.
	errorAndResult := (queues at: id put: SharedQueue new) next.
	self flag: #todo. "thread-safe!"
	queues removeKey: id.
	^ errorAndResult second