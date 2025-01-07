message dispatch
evaluateMessageSend: aMessageSend id: id

	| promise |
	promise := Promise new.
	
	[| result error |
	result := [aMessageSend value]
		on: Error , Warning ", Halt"
		do: [:ex | error := {ex. ex currentStack}].
	error
		ifNil: [promise resolveWith: result]
		ifNotNil: [promise rejectWith: error]]
			forkAt: 29 named: ('Yaros message {1}' format: {id}).
	
	^ promise