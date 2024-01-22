as yet unclassified
startHTTPServer

	serverProcess := [self outputStream do: [:ea |
		| response |
		response := WebClient new
			httpPost: self outputUrl
			content: ea
			type: 'application/json'.
		self assert: response isSuccess]]
			forkAt: 30.