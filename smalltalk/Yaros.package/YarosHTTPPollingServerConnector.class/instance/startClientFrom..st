control
startClientFrom: inputStream

	client := WebServer new.
	client listenOn: self clientPort.
	client
		addService: '/comm'
		action: [:req |
			"Transcript showln: ('{1}: client got...' format: {self}).
			Transcript showln: ('{1}: client got {2}' format: {self. req content})."
			req isOptionsRequest ifFalse:
				[inputStream nextPut: req content].
			req send200Response: 'ok' contentType: 'text/plain' do: [:res |
				res headerAt: 'Access-Control-Allow-Origin' put: '*'.
				res headerAt: 'Access-Control-Allow-Methods' put: 'GET, POST, OPTIONS'.
				res headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type'].
			"Transcript showln: ('{1}: client responded' format: {self})"]
		methods: #('GET' 'POST' 'OPTIONS').