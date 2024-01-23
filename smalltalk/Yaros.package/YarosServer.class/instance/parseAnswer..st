compiling and parsing
parseAnswer: json

	| id object |
	id := json id.
	object := self parseObject: json object.
	^ id -> object