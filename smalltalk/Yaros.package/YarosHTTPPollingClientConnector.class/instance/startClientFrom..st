control
startClientFrom: inputStream

	clientProcess := [| webClient |
	webClient := self newWebClient
		timeout: self pollingTimeout seconds;
		yourself.
	[| response |
	response := webClient httpGet: self clientUrl.
	self assert: response isSuccess.
	"Transcript showln: ('{1}: client got {2}' format: {self. response content})."
	inputStream nextPut: response content]
		repeat]
			forkAt: 30.