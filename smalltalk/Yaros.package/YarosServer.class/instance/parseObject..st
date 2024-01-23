compiling and parsing
parseObject: json

	json isDictionary ifTrue:
		[| id |
		json symbol ifNotNil: [:symbol | ^ symbol asSymbol].
		id := json id.
		^ sharedObjects at: id ifAbsent:
			[YarosRemoteObject server: self id: id]].
	
	^ json