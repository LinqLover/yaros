instance creation
newFor: name server: aServer

	^ (self newForServer: aServer)
		name: name;
		yourself