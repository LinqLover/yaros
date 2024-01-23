printing
printOn: aStream

	super printOn: aStream.
	
	aStream
		space;
		nextPutAll: self remoteName;
		space;
		print: self clientPort;
		nextPut: $/;
		print: self serverPort.