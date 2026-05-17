*Yaros-converting
asYarosJsonObjectWith: aServer

	self isNaN ifTrue: [^ JsonObject new number: 'nan'; yourself].
	self isInfinite ifTrue:
		[^ JsonObject new
			number: (self negative ifTrue: ['-inf'] ifFalse: ['inf']);
			yourself].
	^ self