accessing
messageText

	^ messageText ifNil: [messageText :=
		[self exception description] ifError: [:msg | '<{1}>' format: {msg}]]