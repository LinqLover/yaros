control
startClientFrom: inputStream

	webSocket := WebClient webSocketTo: self serverUrl.
	webSocket onMessage: [:data |
		inputStream nextPut: data].
	webSocket fork.