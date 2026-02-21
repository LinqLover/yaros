as yet unclassified
examplesJS

	"start server in JavaScript"
	
	| asJson eval yaros2 |
	yaros2 := YarosServer new
		connector: (YarosWebSocketClientConnector remoteName: 'localhost' port: 8082);
		yourself.
	yaros2 debugLog: Transcript.
	
	yaros2 restart.

	
	(yaros2 get: 'console') log: 'hi'.
	(yaros2 get: #console) log: Object new.
	((yaros2 get: #eval) value: '[1]') map: [:x | x asWords].
	
	eval := yaros2 get: #eval.
	eval value: '1+2*3'.
	(eval value: '[1]') map: (eval value: '(x) => x + 1').
	(eval value: '[1]') map: [:x | x asWords].
	
	(yaros2 get: #Date) new.
	((yaros2 get: #fetch) value: 'https://wttr.in/?format=%T%20-%20%C+%t') text.
	asJson := [:x | (yaros2 get: #JSON) stringify: x].
(asJson value: (((yaros2 get: #eval) value: 'import("npm:gpt-tokenizer/model/gpt-4o")') encode: 'hello world')) parseAsJson.