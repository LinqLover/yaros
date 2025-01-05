instance creation
newFor: aMessage exception: anException server: aServer

	^ (self newForServer: aServer)
		message: aMessage;
		exception: anException;
		yourself