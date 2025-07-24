system startup
startUp: resuming

	resuming ifTrue:
		[PendingRestart ifNotNil:
			[PendingRestart removeAllSuchThat: [:ea |
				ea wantsRestart ifTrue:
					[ea startUp].
				true].
			PendingRestart := nil]].