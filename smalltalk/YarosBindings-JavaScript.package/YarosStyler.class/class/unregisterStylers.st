registration
unregisterStylers

	self allSubclassesDo: [:ea |
		ea isAbstract ifFalse:
			[ea unregisterStyler]].