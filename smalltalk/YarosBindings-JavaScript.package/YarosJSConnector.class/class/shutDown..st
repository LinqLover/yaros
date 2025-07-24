system startup
shutDown: quitting

	quitting ifTrue:
		[PendingRestart := OrderedCollection new.
		self allSubInstancesDo: [:ea |
			ea isRunning ifTrue:
				[ea shutDown.
				PendingRestart addFirst: ea]]].