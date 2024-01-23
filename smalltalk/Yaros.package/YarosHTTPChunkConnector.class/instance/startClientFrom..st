control
startClientFrom: inputStream

	| start chunks |
	client := WebClient new.
	start := [self error].
	start := [| response responseStream |
		[:exit | client httpGet: self serverUrl do: [:request |
		"request headerAt: 'transfer-encoding' put: 'chunked'"
		response := request newResponse.
		client sendRequest: request contentBlock: [:stream |
			responseStream := stream.
			exit value]]] valueWithExit.
	chunks := Generator on: [:gen |
		[response chunkFrom: responseStream to: gen progress: nil]
			ensure: [response close]].
	
	[clientProcess := [[chunks atEnd] whileFalse:
		[inputStream nextPut: chunks nextLine]]
			on: ConnectionTimedOut do: [start value]]
				forkAt: 30].
	start value.