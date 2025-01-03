control
startServerOn: outputStreamBlock

	serverProcess :=
		[outputStreamBlock value do: [:ea |
			ea ifNotNil:
				[webSocket send: ea]]]
			forkAt: 30.