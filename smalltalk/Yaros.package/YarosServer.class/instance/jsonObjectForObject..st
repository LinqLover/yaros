as yet unclassified
jsonObjectForObject: anObject

	^ localObjects at: anObject ifAbsentPut:
		[| id |
		id := UUID new asString.
		sharedObjects at: id put: anObject.
		JsonObject new
			id: id;
			yourself]