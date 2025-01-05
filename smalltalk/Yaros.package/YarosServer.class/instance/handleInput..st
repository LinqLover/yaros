private
handleInput: input

	| json message |
	"self debugLog ifNotNil: [:log | log showln: ('{1}: raw received: {2}' format: {self. input})."
	input ifEmpty: [^ self].
	json := input parseAsJson.
	json isEmpty ifTrue: [^ self].
	self debugLog ifNotNil: [:log | log showln: ('{1}: received: {2}' format: {self. json printString})].
	json isString ifTrue: [^ self].
	
	message := YarosMessage fromJson: json for: self.
	^ message handleWith: self