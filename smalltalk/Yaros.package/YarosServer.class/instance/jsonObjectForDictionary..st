object conversion
jsonObjectForDictionary: aDictionary

	^ JsonObject new
		dictionary: (self jsonForObject: aDictionary);
		yourself