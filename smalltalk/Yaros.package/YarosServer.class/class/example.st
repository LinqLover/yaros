as yet unclassified
example

	"image 1:"
	| yaros1 yaros2 process |
	yaros1 := YarosServer new
		"connector: (YarosHTTPClientAndServerConnector remoteName: 'localhost' clientPort: 8082 serverPort: 8083);"
		connector: (YarosWebSocketServerConnector remoteName: 'localhost' port: 8082);
		yourself.
	yaros1 startServer.
	yaros1 startClient.
	
	"image 2:"
	yaros2 := YarosServer new
		"connector: (YarosHTTPClientAndServerConnector remoteName: 'localhost' clientPort: 8083 serverPort: 8082);"
		connector: (YarosWebSocketClientConnector remoteName: 'localhost' port: 8082)
		yourself.
	yaros2 startServer.
	yaros2 startClient.
	
	"simple"
	yaros1 evaluate: (MessageSend receiver: 6 selector: #* arguments: #(10)).
	"simple callback"
	yaros1 evaluate: (MessageSend receiver: 6 selector: #* arguments: #((10))).
	"remote objects"
	(yaros1 get: #Smalltalk) imageName.
	(yaros1 get: #Compiler) evaluate: '2+3'.
	
	"models"
	ToolBuilder open: ((yaros1 get: #Workspace) new shouldStyle: false; yourself). "not yet evaluated remotely"
	ToolBuilder open: (Inspector new object: (yaros1 get: #Smalltalk)). "no global bindings yet"
	ToolBuilder open: (MorphInspector new object: (yaros1 get: #World)).
ToolBuilder open: (ObjectExplorer explore: (yaros1 get: #World)).
	ToolBuilder open: ((yaros1 get: #Compiler) evaluate: 'ObjectExplorer explore: World').
	
	Browser fullOnEnvironment: (yaros1 get: #Smalltalk) environment.
	ToolBuilder default open: ((yaros1 get: #Browser) new selectEnvironment: (yaros1 get: #Smalltalk) environment; buildDefaultBrowserWith: ToolBuilder default).
	
	process := (yaros1 get: #Compiler) evaluate: '[Smalltalk imageName] newProcess'.
	Debugger openOnCue: (DebuggerInvocationCue new process: process; context: process suspendedContext; fullView: true). "slightly works, slow (communicaiton with process), still saw one emergency evaluator from this (not sure whether specifically from debugger)"
ToolBuilder open: (((yaros1 get: #Debugger) onProcess: process context: process suspendedContext) initializeFull; buildFullWith: ToolBuilder default label: 'remote debugger'). "slightly works, slow (dependents updates - approx same speed as other)"
	
	ToolBuilder open: (yaros1 get: #ProcessBrowser). "ui selection does nto work, menus commands open in wrong image"
ToolBuilder open: (ProcessBrowser new instVarNamed: 'processClass' put: (yaros1 get: #Process); yourself).
	
	RemoteMorph openOn: (yaros1 get: #TextMorph) new.
RemoteMorph openOn: ((yaros1 get: #Compiler) evaluate: 'ToolBuilder build: Workspace').
RemoteMorph openOn: ((yaros1 get: #Compiler) evaluate: '(Browser fullOnEnvironment: Smalltalk environment) containingWindow').