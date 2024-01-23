as yet unclassified
startHTTPClient

	client := WebServer new.
	client listenOn: self inputPort.
	client
		addService: '/comm'
		action: [:req |
			req isOptionsRequest ifFalse:
				[inputs nextPut: req content].
			req send200Response: 'ok' contentType: 'text/plain' do: [:res |
				res headerAt: 'Access-Control-Allow-Origin' put: '*'.
				res headerAt: 'Access-Control-Allow-Methods' put: 'GET, POST, OPTIONS'.
				res headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type']]
		methods: #('GET' 'POST' 'OPTIONS').
	
	inputProcess := [[self handleInput: inputs next] repeat] forkAt: 30.