compiling and parsing
parseObject: json

	json isDictionary ifTrue:
		[| id |
		json dictionary ifNotNil: [:dictionary | ^ dictionary].
		json symbol ifNotNil: [:symbol | ^ symbol asSymbol].
		json character ifNotNil: [:character | ^ character first].
		id := json id.
		^ sharedObjects at: id ifAbsent:
			[YarosRemoteObject server: self id: id]].
	
	^ json