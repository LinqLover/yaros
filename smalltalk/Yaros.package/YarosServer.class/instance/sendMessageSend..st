messaging
sendMessageSend: aMessageSend

	^ self send:
		(YarosMessageSendMessage newFor: aMessageSend server: self)