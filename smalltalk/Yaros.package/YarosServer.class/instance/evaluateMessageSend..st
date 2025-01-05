message dispatch
evaluateMessageSend: aMessageSend

	| promise |
	promise := Promise new.
	
	[| result error |
	result := [aMessageSend value]
		on: Error , Warning ", Halt"
		do: [:ex | error := {ex. ex signalerContext stack}].
	error
		ifNil: [promise resolveWith: result]
		ifNotNil: [promise rejectWith: error]]
			fork.
	
	^ promise