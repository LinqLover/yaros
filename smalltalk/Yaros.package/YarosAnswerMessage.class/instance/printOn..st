printing
printOn: aStream

	super printOn: aStream.
	
	aStream nextPut: $(.
	self result isProxy
		ifFalse: [self result printOn: aStream]
		ifTrue: [aStream nextPutAll: '...'].
	aStream nextPut: $).