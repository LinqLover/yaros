messaging
handleMessageSend: aMessageSend

	[| result error |
	[result := aMessageSend value value]
		on: Error , Warning ", Halt"
		do: [:ex | error := {ex. ex signalerContext stack}].
	self sendAnswer: aMessageSend key result: result error: error] fork.