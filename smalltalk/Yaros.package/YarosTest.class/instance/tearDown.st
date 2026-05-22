running
tearDown

	[yaros1 ifNotNil: [yaros1 stop].
	yaros2 ifNotNil: [yaros2 stop]]
		ensure: [super tearDown].