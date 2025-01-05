control
startClient

	self connector startClientFrom: inputs.
	
	inputProcess := [[self handleInput: inputs next] repeat]
		forkAt: 30 named: ('{1}''s client' format: {self}).
	self connector when: #clientStopped send: #stopClient to: self.