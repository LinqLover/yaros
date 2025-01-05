converting
asJsonFor: aServer

	| json |
	json := super asJsonFor: aServer.
	
	self exception
		ifNil: [json result: (aServer jsonForObject: self result)]
		ifNotNil: [json at: #error put: (aServer jsonForObject: self exception)].
	^ json