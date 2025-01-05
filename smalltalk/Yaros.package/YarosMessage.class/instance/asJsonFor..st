converting
asJsonFor: aServer

	^ JsonObject new
		id: self id;
		type: self class type;
		yourself