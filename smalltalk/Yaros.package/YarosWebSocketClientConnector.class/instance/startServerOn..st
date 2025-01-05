control
startServerOn: outputStreamBlock

	serverProcess :=
		[outputStreamBlock value do: [:ea |
			ea ifNotNil:
				[webSocket send: ea]]]
			forkAt: 30 named: ('{1}''s server' format: {self}).