tests
testRoundtrip

	yaros1 := self serverClass new
		connector: (YarosWebSocketServerConnector remoteName: 'localhost' port: 0);
		yourself.
	yaros1 start.
	
	yaros2 := self serverClass new
		connector: (YarosWebSocketClientConnector remoteName: 'localhost' port: yaros1 connector port);
		yourself.
	yaros2 start.
	
	self assert: yaros1 isRunning.
	self assert: yaros2 isRunning.
	
	self assert: 6 * 7 equals: (yaros1 evaluate: (MessageSend receiver: 6 selector: #* arguments: #(7))).
	self assert: 6 * 7 equals: (yaros2 evaluate: (MessageSend receiver: 6 selector: #* arguments: #(7))).
	
	self assert: 6 * #(7) equals: (yaros1 evaluate: (MessageSend receiver: 6 selector: #* arguments: #((7)))).
	self assert: 6 * #(7) equals: (yaros2 evaluate: (MessageSend receiver: 6 selector: #* arguments: #((7)))).
	
	self assert: Smalltalk imageName equals: (yaros1 get: #Smalltalk) imageName.
	
	yaros1 environment: (Dictionary new
		at: #test put: UUID new;
		yourself).
	
	self assert: (yaros1 environment at: #test) asString equals: (yaros2 get: #test) asString.