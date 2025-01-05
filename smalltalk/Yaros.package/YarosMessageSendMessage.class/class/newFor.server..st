instance creation
newFor: aMessageSend server: aServer

	^ (self newForServer: aMessageSend)
		messageSend: aMessageSend;
		yourself