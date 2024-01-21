as yet unclassified
stopServer

	server ifNotNil:
		[server destroy.
		server := nil].