messaging
sendAnswer: id result: result error: anError

	| json |
	json := JsonObject new
		type: #answer;
		id: id;
		yourself.
	anError
		ifNil: [json result: (self compileObject: result)]
		ifNotNil: [json at: #error put: (self compileObject: anError)].
	^ self send: json