registration
registerStylers

	self allSubclassesDo: [:ea |
		ea isAbstract ifFalse:
			[ea registerStyler]].