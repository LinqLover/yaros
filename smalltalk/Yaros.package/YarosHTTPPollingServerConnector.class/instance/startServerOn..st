control
startServerOn: outputStreamBlock

	| outputStream |
	outputStream := nil.
	server := WebServer new.
	server listenOn: self serverPort.
	server
		addService: '/comm'
		action: [:req |
			| content |
			"Transcript showln: ('{1}: server got {2}' format: {self. req})."
			content := req isOptionsRequest
				ifTrue: ['ok']
				ifFalse: [[(outputStream ifNil: [outputStream := outputStreamBlock value]) next] whileNil].
			"Transcript showln: ('{1}: server about to respond {2}' format: {self. content})."
			req send200Response: content contentType: 'text/plain' do: [:res |
				res headerAt: 'Access-Control-Allow-Origin' put: '*'.
				res headerAt: 'Access-Control-Allow-Methods' put: 'GET, POST, OPTIONS'.
				res headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type'].
			"Transcript showln: ('{1}: server responded {2}' format: {self. content})"]
		methods: #('GET' 'POST' 'OPTIONS').