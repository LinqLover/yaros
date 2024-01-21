as yet unclassified
sendAnswer: answer

	| json |
	json := JsonObject new
		type: #answer;
		id: answer key;
		object: answer value;
		yourself.
	^ self send: json