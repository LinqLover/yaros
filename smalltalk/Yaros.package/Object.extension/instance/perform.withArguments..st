*Yaros-proxies-message handling-override
perform: selector withArguments: argArray 
	"Send the selector, aSymbol, to the receiver with arguments in argArray.
	Fail if the number of arguments expected by the selector 
	does not match the size of argArray.
	Primitive. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 84>
	selector isProxy ifTrue: [^ self perform: selector resolveProxy withArguments: argArray].
	argArray isProxy ifTrue: [^ self perform: selector withArguments: argArray resolveProxyArray].
	^ self perform: selector withArguments: argArray inSuperclass: self class