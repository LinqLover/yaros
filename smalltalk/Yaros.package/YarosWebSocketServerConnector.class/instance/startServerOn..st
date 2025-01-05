control
startServerOn: outputStreamBlock

	serverProcess :=
		[outputStreamBlock value do: [:ea |
			ea ifNotNil:
				[mutex critical:
					[sockets do: [:socket |
						socket  send: ea]]]]]
			forkAt: 30 named: ('{1}''s server' format: {self}).