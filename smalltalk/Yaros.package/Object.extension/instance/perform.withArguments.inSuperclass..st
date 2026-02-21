*Yaros-proxies-message handling-override
perform: selector withArguments: argArray inSuperclass: lookupClass
	"NOTE:  This is just like perform:withArguments:, except that
	the message lookup process begins, not with the receivers's class,
	but with the supplied superclass instead.  It will fail if lookupClass
	cannot be found among the receiver's superclasses.
	Primitive. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 100 error: error>
	error == #'inappropriate operation' ifTrue:
		[^self error: 'argArray is recursive'].
	
	argArray isProxy ifTrue: [^ self perform: selector withArguments: argArray resolveProxy inSuperclass: lookupClass].
	lookupClass isProxy ifTrue: [^ self perform: selector withArguments: argArray inSuperclass: lookupClass resolveProxy].
	
	selector isSymbol ifFalse:
		[^self error: 'selector argument must be a Symbol'].
	selector numArgs = argArray size ifFalse:
		[^self error: 'incorrect number of arguments'].
	(self class == lookupClass or: [self class inheritsFrom: lookupClass]) ifFalse:
		[^self error: 'lookupClass is not in my inheritance chain'].
	self primitiveFailed