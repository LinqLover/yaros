messaging
sendMessageSend: aMessageSend

	| json |
	json := self compileMessageSend: aMessageSend.
	self send: json.
	^ json id