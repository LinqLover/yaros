messaging
handleLookup: lookup

	[self
		sendAnswer: lookup key
		result: (self environment at: lookup value ifAbsent: [nil])
		error: nil] fork.