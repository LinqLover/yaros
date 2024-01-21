converting
asYarosJsonObjectWith: aServer

	aServer == server ifFalse: [^ super asYarosJsonObjectWith: aServer].
	^ aServer jsonObjectForRemoteObject: self