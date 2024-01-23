control
startServerOn: outputStreamBlock

	serverProcess := [| webClient |
	webClient := self newWebClient.
	outputStreamBlock value do: [:ea |
		| response |
		"Transcript showln: ('{1}: server about to post {2}' format: {self. ea})."
		response := webClient
			httpPost: self serverUrl
			content: ea
			type: 'application/json'.
		"Transcript showln: ('{1}: server posted {2}' format: {self. ea})."
		self assert: response isSuccess]]
			forkAt: 30.