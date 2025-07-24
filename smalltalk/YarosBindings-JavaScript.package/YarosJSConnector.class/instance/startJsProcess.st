private
startJsProcess

	jsProcess ifNotNil: [self stopJsProcess].
	
	jsProcess := PipeableOSProcess command: 'exec deno run --allow-all main.js --port ' , (self serverPort ifNil: [0])
		environment: nil
		workingDir: self serverDirectory
		input: nil
		output: nil
		error: nil
		errorPipelineStream: nil.
	
	actualServerPort := self findServerPort.
	self serverPort ifNotNil: [:expected | self assert: expected = actualServerPort].