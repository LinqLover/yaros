control
stopClient

	webSocket ifNotNil:
		[webSocket close.
		webSocket := nil].