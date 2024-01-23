messaging
handleLookup: lookup

	[self sendAnswer: lookup key -> (self environment at: lookup value ifAbsent: [nil])] fork.