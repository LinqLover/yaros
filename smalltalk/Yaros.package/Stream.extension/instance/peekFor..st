*Yaros-pseudo-override
peekFor: anObject

	self atEnd ifTrue: [^ false].
	self peek = anObject ifFalse: [^ false].
	self next.
	^ true