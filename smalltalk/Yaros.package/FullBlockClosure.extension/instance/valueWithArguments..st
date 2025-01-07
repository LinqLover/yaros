*Yaros-proxies-evaluating-override
valueWithArguments: anArray
	"Activate the receiver, creating a closure activation (MethodContext)
	 whose closure is the receiver and whose caller is the sender of this
	 message. Supply the arguments in an anArray and copied values to
	 the activation as its arguments and copied temps. Primitive. Essential."
	<primitive: 208>
	anArray isProxy ifTrue: [^ self valueWithArguments: anArray resolveProxyArray].
	numArgs ~= anArray size ifTrue:
		[self numArgsError: anArray size].
	^self primitiveFailed