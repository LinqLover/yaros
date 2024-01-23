messaging
send: json

	Transcript showln: ('{1}: send: {2}' format: {self. json printString}).
	
	outputs nextPut: json asJsonString.
	(self connector isKindOf: YarosHTTPClientAndServerConnector) ifTrue:
		[self flag: #workaround. "otherwise messages are send to late???"
		outputs nextPut: '{}'.].
	(self connector isKindOf: YarosHTTPChunkConnector) ifTrue:
		[self flag: #workaround. "otherwise messages are send to late???"
		outputs nextPut: '{}'.
		outputs nextPut: '{}'.
		outputs nextPut: '{}'].