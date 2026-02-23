*Yaros-resolving-pseudo-override
resolveWithValue: arg

	self flag: #moveUpstream.
	mutex critical: [
		(state == #pending) ifTrue: [ | worklist |
			value := arg.
			state := #fulfilled.
			worklist := resolvers.
			resolvers := #().
			rejecters := #().
			worklist do: [:r | self evaluateResolver: r]]]