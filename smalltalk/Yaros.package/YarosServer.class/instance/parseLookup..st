as yet unclassified
parseLookup: json

	| id name |
	id := json id.
	name := self parseObject: json name.
	^ id -> name