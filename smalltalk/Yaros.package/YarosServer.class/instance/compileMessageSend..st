compiling and parsing
compileMessageSend: aMessageSend

	^ JsonObject new
		type: #messageSend;
		id: UUID new asString;
		receiver: (self compileObject: aMessageSend receiver);
		selector: aMessageSend selector;
		arguments: (aMessageSend arguments collect: [:ea | self compileObject: ea]);
		yourself