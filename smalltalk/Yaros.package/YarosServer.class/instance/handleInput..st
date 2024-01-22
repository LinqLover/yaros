as yet unclassified
handleInput: input

	| json |
	"Transcript showln: ('{1}: raw received: {2}' format: {self. input})."
	input ifEmpty: [^ self].
	json := input parseAsJson.
	json isEmpty ifTrue: [^ self].
	Transcript showln: ('{1}: received: {2}' format: {self. json printString}).
	json isString ifTrue: [^ self].
	
	json type
		caseOf:
			{[#messageSend] -> [self "halt" handleMessageSend: (self parseMessageSend: json)].
			[#answer] -> [self handleAnswer: (self parseAnswer: json)].
			[#lookup] -> [self handleLookup: (self parseLookup: json)]}
	