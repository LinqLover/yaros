style table
attributesFor: aSymbol

	| stType |
	stType := (self stTypeFor: aSymbol) ifNil: [^ #()].
	^ SHTextStylerST80 new attributesFor: stType