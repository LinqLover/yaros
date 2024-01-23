compiling and parsing
parseMessageSend: json

	| id arguments receiver |
	receiver := self parseObject: json receiver.
	arguments := json arguments collect: [:ea | self parseObject: ea].
	id := json id.
	^ id ->
		(MessageSend
			receiver: receiver
			selector: json selector asSymbol
			arguments: arguments)