public
evaluate: aMessageSend

	| id result |
	"self halt: aMessageSend selector."
	id := self sendMessageSend: aMessageSend.
	result := (queues at: id put: SharedQueue new) next.
	self flag: #todo. "thread-safe!"
	self flag: #bug. "must create queue prior to sending!"
	queues removeKey: id.
	^ result