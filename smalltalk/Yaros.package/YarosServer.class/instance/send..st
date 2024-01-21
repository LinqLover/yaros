as yet unclassified
send: json

	Transcript showln: ('{1}: send: {2}' format: {self. json printString}).
	
	outputs nextPut: json asJsonString.
	outputs nextPut: '{}'.
	outputs nextPut: '{}'.
	outputs nextPut: '{}'. "otherwise messages are send to late???"