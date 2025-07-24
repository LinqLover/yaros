initialize-release
cleanUp: aggressive

	aggressive ifTrue:
		[Default ifNotNil:
			[Default stop.
			Smalltalk globals removeKey: #JS ifAbsent: []]].