as yet unclassified
startClient

	| start |
	client := WebClient new.
	start := [self error].
	start := [| response responseStream |
		[:exit | client httpGet: self inputUrl do: [:request |
		"request headerAt: 'transfer-encoding' put: 'chunked'"
		response := request newResponse.
		client sendRequest: request contentBlock: [:stream |
			responseStream := stream.
			exit value]]] valueWithExit.
	inputStream := Generator on: [:gen |
		[response chunkFrom: responseStream to: gen progress: nil]
			ensure: [response close]].
	
	[clientProcess := [[inputStream atEnd] whileFalse:
		[inputs nextPut: inputStream nextLine]]
			on: ConnectionTimedOut do: [start value]]
				forkAt: 30].
	start value.
	
	inputProcess := [[self handleInput: inputs next] repeat] forkAt: 30.