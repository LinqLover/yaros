initialize-release
defaultWebClientFactory

	^ MessageSend receiver: (Smalltalk classNamed: #WebClient) selector: #new