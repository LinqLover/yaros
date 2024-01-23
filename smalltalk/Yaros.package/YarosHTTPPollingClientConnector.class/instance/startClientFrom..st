control
startClientFrom: inputStream

	clientProcess := [[
		| response |
		response := WebClient new
			timeout: self pollingTimeout seconds;
			httpGet: self clientUrl.
		self assert: response isSuccess.
		"Transcript showln: ('{1}: client got {2}' format: {self. response content})."
		inputStream nextPut: response content]
			repeat]
		forkAt: 30.