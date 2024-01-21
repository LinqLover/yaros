as yet unclassified
printOn: aStream

	super printOn: aStream.
	
	aStream
		space;
		nextPutAll: self serverName;
		space;
		print: self inputPort;
		nextPut: $/;
		print: self outputPort.