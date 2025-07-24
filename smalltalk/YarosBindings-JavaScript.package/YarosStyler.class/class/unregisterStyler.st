registration
unregisterStyler

	self assert: self isAbstract not.
	TextStyler unregister: self for: self language.