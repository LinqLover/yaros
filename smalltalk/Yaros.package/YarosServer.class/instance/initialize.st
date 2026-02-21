initialize-release
initialize

	super initialize.
	
	self environment: self class environment.
	
	inputs := SharedQueue new.
	outputs := SharedQueue new.
	
	localObjects := IdentityDictionary new.
	sharedObjects := Dictionary new.
	remoteObjects := Dictionary new.
	queues := Dictionary new.
	serverRunning := false.