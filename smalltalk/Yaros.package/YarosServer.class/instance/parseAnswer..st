compiling and parsing
parseAnswer: json

	| id result error |
	id := json id.
	error := self parseObject: (json at: #error).
	result := self parseObject: json result.
	^ id -> {error. result}