compiling and parsing
compileLookup: aString

	^ JsonObject new
		type: #lookup;
		id: UUID new asString;
		name: (self compileObject: aString);
		yourself