messaging
send: json

	self debugLog ifNotNil: [:log | log showln: ('{1}: send: {2}' format: {self. json printString})].
	
	outputs nextPut: json asJsonString.
	self flag: #workaround. "otherwise messages are sent too late???"
	outputs nextPut: '{}'.
	(self connector isKindOf: YarosHTTPChunkConnector) ifTrue:
		[self flag: #workaround. "otherwise messages are sent too late???"
		outputs nextPut: '{}'.
		outputs nextPut: '{}'].