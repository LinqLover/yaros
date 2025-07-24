registration
useStyler: aBoolean

	UseStyler := aBoolean.
	self useStyler
		ifTrue: [self registerStylers]
		ifFalse: [self unregisterStylers].