printing
shortPrintOn: aStream

	aStream
		nextPutAll: 'Yaros WS client ';
		print: self serverPort.