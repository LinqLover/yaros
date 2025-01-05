converting
asJsonFor: aServer

	^ (super asJsonFor: aServer)
		name: (aServer jsonForObject: self name);
		yourself