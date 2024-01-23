compiling and parsing
jsonObjectForCharacter: aCharacter

	^ JsonObject new
		character: aCharacter asString;
		yourself