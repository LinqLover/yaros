as yet unclassified
example

	"image 1:"
	| yaros1 yaros2 |
	yaros1 := YarosServer serverName: 'localhost' inputPort: 8082 outputPort: 8083.
	yaros1 startServer.
	yaros1 startClient.
	
	"image 2:"
	yaros2 := YarosServer serverName: 'localhost' inputPort: 8083 outputPort: 8082.
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