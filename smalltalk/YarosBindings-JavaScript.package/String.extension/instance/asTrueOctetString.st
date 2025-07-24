*YarosBindings-JavaScript-converting
asTrueOctetString

	^ self collect: [:ea | ea isOctetCharacter ifFalse: [$?] ifTrue: [ea]] as: ByteString