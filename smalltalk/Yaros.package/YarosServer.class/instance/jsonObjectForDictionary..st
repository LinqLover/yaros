compiling and parsing
jsonObjectForDictionary: aDictionary

	^ JsonObject new
		dictionary: (self compileObject: aDictionary);
		yourself