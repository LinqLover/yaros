control
startServer

	(self connector respondsTo: #unblockServerBlock:) ifTrue:
		[self connector unblockServerBlock: [self send: 'hi']].
	
	self connector startServerOn:
		[Generator on: [:gen |
			[gen nextPut: outputs next] repeat]].
	serverRunning := true.