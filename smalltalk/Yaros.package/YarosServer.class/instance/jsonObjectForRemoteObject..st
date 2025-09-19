object conversion
jsonObjectForRemoteObject: aRemoteObject

	^ JsonObject new
		remoteId: aRemoteObject xxxId;
		yourself