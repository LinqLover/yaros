initialize-release
initializeYaros

	yaros := YarosServer newJS.
	self name ifNotNil:
		[yaros name: self name].
	yaros connector: (YarosWebSocketClientConnector remoteName: 'localhost' clientPort: nil serverPort: -1 "will be set in startYaros").