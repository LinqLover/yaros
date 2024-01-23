control
stopClient

	client ifNotNil:
		[client destroy.
		client := nil].