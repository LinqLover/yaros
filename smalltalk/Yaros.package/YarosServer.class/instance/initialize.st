as yet unclassified
initialize

	super initialize.
	
	inputs := SharedQueue new.
	outputs := SharedQueue new.
	
	localObjects := IdentityDictionary new.
	sharedObjects := Dictionary new.
	remoteObjects := Dictionary new.
	queues := Dictionary new.