message dispatch
lookup: aSymbol

	^ self environment at: aSymbol ifAbsent: [nil]