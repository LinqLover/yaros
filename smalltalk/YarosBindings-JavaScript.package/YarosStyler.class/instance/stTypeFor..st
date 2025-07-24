style table
stTypeFor: type

	type = #default ifTrue: [^ nil].
	^ type
		caseOf: {
			[#comment] -> [#comment].
			[#keyword] -> [#thisContext].
			[#params] -> [#methodArg].
			[#number] -> [#number].
			[#string] -> [#string].
			[#'built_in'] -> [#self].
			[#subst] -> [#string].
			[#title] -> [#globalVar].
			[#attr] -> [#keyword].
			[#property] -> [#keyword].
			[#function] -> ["???" nil].
			[#variable] -> [#tempVar].	
			[#literal] -> [#number "?"].
			[#name] -> [#keyword]}
		otherwise: [self halt]