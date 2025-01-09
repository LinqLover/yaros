as yet unclassified
examplesJS

	"start server in JavaScript"
	
	| asJson eval yaros2 |
	yaros2 := YarosServer new
		connector: (YarosWebSocketServerConnector remoteName: 'localhost' clientPort: 8082 serverPort: nil);
		yourself.
	yaros2 debugLog: Transcript.
	
	yaros2 restart.

	
	(yaros2 remoteObjectNamed: 'console') log: 'hi'.
	(yaros2 remoteObjectNamed: #console) log: Object new.
	((yaros2 remoteObjectNamed: #eval) value: '[1]') map: [:x | x asWords].
	
	eval := yaros2 remoteObjectNamed: #eval.
	eval value: '2+3'.
	(eval value: '[1]') map: (eval value: '(x) => x + 1').
	(eval value: '[1]') map: [:x | x asWords].
	
	(yaros2 remoteObjectNamed: #Date) new.
	((yaros2 remoteObjectNamed: #fetch) value: 'https://wttr.in/?format=%T%20-%20%C+%t') text.
	asJson := [:x | (yaros2 remoteObjectNamed: #JSON) stringify: x].
	asJson value: (((yaros2 remoteObjectNamed: #eval) value: 'import("npm:gpt-tokenizer/model/gpt-4o")') encode: 'hello world') parseAsJson.