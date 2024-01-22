as yet unclassified
startHTTPClient

	client := WebServer new.
	client listenOn: self outputPort.
	client addService: '/comm' action: [:req |
		inputs nextPut: req content.
		req send200Response: 'ok'].
	
	inputProcess := [[self handleInput: inputs next] repeat] forkAt: 30.