style table
stTypeFor: type

	type = #regexp ifTrue: [^ #string].
	^ super stTypeFor: type