as yet unclassified
example

	"image 1:"
	| yaros1 yaros2 process |
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
	
	"models"
	ToolBuilder open: ((yaros1 remoteObjectNamed: #Workspace) new shouldStyle: false; yourself). "not yet evaluated remotely"
	ToolBuilder open: (Inspector new object: (yaros1 remoteObjectNamed: #Smalltalk)). "no global bindings yet"
	ToolBuilder open: (MorphInspector new object: (yaros1 remoteObjectNamed: #World)).
ToolBuilder open: (ObjectExplorer explore: (yaros1 remoteObjectNamed: #World)).
	ToolBuilder open: ((yaros1 remoteObjectNamed: #Compiler) evaluate: 'ObjectExplorer explore: World').
	
	Browser fullOnEnvironment: (yaros1 remoteObjectNamed: #Smalltalk) environment.
	ToolBuilder default open: ((yaros1 remoteObjectNamed: #Browser) new selectEnvironment: (yaros1 remoteObjectNamed: #Smalltalk) environment; buildDefaultBrowserWith: ToolBuilder default).
	
	process := (yaros1 remoteObjectNamed: #Compiler) evaluate: '[Smalltalk imageName] newProcess'.
	Debugger openOnCue: (DebuggerInvocationCue new process: process; context: process suspendedContext; fullView: true). "slightly works, slow (communicaiton with process), still saw one emergency evaluator from this (not sure whether specifically from debugger)"
ToolBuilder open: (((yaros1 remoteObjectNamed: #Debugger) onProcess: process context: process suspendedContext) initializeFull; buildFullWith: ToolBuilder default label: 'remote debugger'). "slightly works, slow (dependents updates - approx same speed as other)"
	
	ToolBuilder open: (yaros1 remoteObjectNamed: #ProcessBrowser). "ui selection does nto work, menus commands open in wrong image"
ToolBuilder open: (ProcessBrowser new instVarNamed: 'processClass' put: (yaros1 remoteObjectNamed: #Process); yourself).
	
	RemoteMorph openOn: (yaros1 remoteObjectNamed: #TextMorph) new.
RemoteMorph openOn: ((yaros1 remoteObjectNamed: #Compiler) evaluate: 'ToolBuilder build: Workspace').
RemoteMorph openOn: ((yaros1 remoteObjectNamed: #Compiler) evaluate: '(Browser fullOnEnvironment: Smalltalk environment) containingWindow').