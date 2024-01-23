as yet unclassified
example

	"image 1:"
	| yaros1 yaros2 |
	yaros1 := YarosServer new
		connector: (YarosHTTPClientAndServerConnector remoteName: 'localhost' clientPort: 8082 serverPort: 8083);
	yourself.
	yaros1 startServer.
	yaros1 startClient.
	
	"image 2:"
	yaros2 := YarosServer new
		connector: (YarosHTTPClientAndServerConnector remoteName: 'localhost' clientPort: 8083 serverPort: 8082);
		yourself.
	yaros2 startServer.
	yaros2 startClient.
	
	"simple"
	yaros1 evaluate: (MessageSend receiver: 6 selector: #* arguments: #(10)).
	"simple callback"
	yaros1 evaluate: (MessageSend receiver: 6 selector: #* arguments: #((10))).
	"remote objects"
	(yaros1 remoteObjectNamed: #Smalltalk) imageName.
	(yaros1 remoteObjectNamed: #Compiler) evaluate: '2+3'.
	"way too slow unfortunately"
	"ToolBuilder open: ((yaros1 remoteObjectNamed: #Workspace))."