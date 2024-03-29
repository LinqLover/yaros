control
startServerOn: outputStreamBlock

	serverProcess := [outputStreamBlock value do: [:ea |
		ea ifNotNil:
			[| response |
			response := WebClient new
				httpPost: self serverUrl
				content: ea
				type: 'application/json'.
			self assert: response isSuccess]]]
		forkAt: 30.