object conversion
objectFromJson: json

	json isDictionary ifTrue:
		[| id |
		json symbol ifNotNil: [:symbol | ^ symbol asSymbol].
		json character ifNotNil: [:character | ^ character first].
		id := json id.
		^ sharedObjects at: id ifAbsent:
			[YarosRemoteObject server: self id: id]].
	
	^ json