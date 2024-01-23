control
startClient

	self connector startClientFrom: inputs.
	
	inputProcess := [[self handleInput: inputs next] repeat] forkAt: 30.