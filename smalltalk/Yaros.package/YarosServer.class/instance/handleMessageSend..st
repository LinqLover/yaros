as yet unclassified
handleMessageSend: aMessageSend

	"self halt: aMessageSend value selector."
	[self sendAnswer: aMessageSend key -> aMessageSend value value] fork.