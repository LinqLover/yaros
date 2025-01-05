messaging
sendAnswerTo: aMessage error: anException

	^ self send:
		(YarosAnswerMessage
			newFor: aMessage
			exception: anException
			server: self)