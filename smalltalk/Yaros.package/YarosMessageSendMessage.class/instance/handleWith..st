handling
handleWith: aServer

	(aServer evaluateMessageSend: self messageSend)
		whenResolved: [:result |
			aServer
				sendAnswerTo: self
				result: result];
		whenRejected: [:error |
			aServer
				sendAnswerTo: self
				error: error].