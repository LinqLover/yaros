initialize-release
initialize

	super initialize.
	self initializeYaros.
	self serverDirectory: self class defaultServerDirectory.