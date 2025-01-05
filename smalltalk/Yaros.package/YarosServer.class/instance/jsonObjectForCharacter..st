object conversion
jsonObjectForCharacter: aCharacter

	^ JsonObject new
		character: aCharacter asString;
		yourself