instance creation
newFor: aMessage result: result server: aServer

	^ (self newForServer: aServer)
		message: aMessage;
		result: result;
		yourself