registration
registerStyler

	self assert: self isAbstract not.
	TextStyler register: self for: self language.