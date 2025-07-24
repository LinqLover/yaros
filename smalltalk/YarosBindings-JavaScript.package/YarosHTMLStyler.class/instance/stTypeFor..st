style table
stTypeFor: type

	^ type
		caseOf:
			{[#tag] -> [#keyword].
			['selector-tag'] -> [#global].
			[#attribute] -> [#keyword]}
		otherwise: [super stTypeFor: type]