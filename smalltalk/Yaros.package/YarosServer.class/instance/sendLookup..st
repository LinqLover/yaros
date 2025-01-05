messaging
sendLookup: name

	^ self send:
		(YarosLookupMessage newFor: name server: self)