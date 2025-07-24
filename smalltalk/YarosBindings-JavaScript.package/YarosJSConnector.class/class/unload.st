initialize-release
unload

	self cleanUp: true.
	Smalltalk removeFromShutDownList: self.
	Smalltalk removeFromStartUpList: self.