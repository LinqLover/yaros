printing
shortPrintOn: aStream

	aStream
		nextPutAll: 'Yaros WS server ';
		print: self clientPort.