compiling and parsing
parseLookup: json

	| id name |
	id := json id.
	name := self parseObject: json name.
	^ id -> name