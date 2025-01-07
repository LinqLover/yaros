accessing
messageText

	^ messageText ifNil: [messageText :=
		[self exception description] on: Error do: [:ex |
			'<description error>']]