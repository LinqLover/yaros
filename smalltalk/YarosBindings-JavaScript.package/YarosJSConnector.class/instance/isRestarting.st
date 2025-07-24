testing
isRestarting

	^ PendingRestart notNil and: [PendingRestart identityIncludes: self]