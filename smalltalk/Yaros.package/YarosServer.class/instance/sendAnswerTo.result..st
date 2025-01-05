messaging
sendAnswerTo: aMessage result: result

	^ self send:
		(YarosAnswerMessage
			newFor: aMessage
			result: result
			server: self)