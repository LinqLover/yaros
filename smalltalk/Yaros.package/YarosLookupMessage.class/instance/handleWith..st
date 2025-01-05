handling
handleWith: aServer

	| result |
	result := aServer lookup: self name.
	^ aServer
		sendAnswerTo: self
		result: result