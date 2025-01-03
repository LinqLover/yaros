control
startServerOn: outputStreamBlock

	serverProcess :=
		[outputStreamBlock value do: [:ea |
			ea ifNotNil:
				[mutex critical:
					[sockets do: [:socket |
						socket  send: ea]]]]]
			forkAt: 30.