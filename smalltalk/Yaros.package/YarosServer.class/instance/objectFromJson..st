object conversion
objectFromJson: json

	json isDictionary ifTrue:
		[| id |
		json symbol ifNotNil: [:symbol | ^ symbol asSymbol].
		json character ifNotNil: [:character | ^ character first].
		json remoteId ifNotNil: [:rid | ^ sharedObjects at: rid].
		id := json id.
		^ sharedObjects at: id ifAbsent:
			[self remoteObjectClass server: self id: id]].
	
	^ json