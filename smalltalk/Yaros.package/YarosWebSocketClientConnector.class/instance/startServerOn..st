control
startServerOn: outputStreamBlock

	serverProcess :=
		[[outputStreamBlock value do: [:ea |
			ea ifNotNil:
				[webSocket send: ea]]]
			on: MessageNotUnderstood do: [:ex |
				webSocket ifNil:
					[self triggerEvent: #serverStopped]. "haven't that been we ourselves?"
				ex pass]
			on: SocketPrimitiveFailed do: [:ex |
				self triggerEvent: #serverStopped.
				ex pass]]
			forkAt: 30 named: ('{1}''s server' format: {self shortPrintString}).