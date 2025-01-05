initialize-release
initializeFromJson: json for: aServer

	| receiver arguments |
	super initializeFromJson: json for: aServer.
	
	receiver := aServer objectFromJson: json receiver.
	arguments := json arguments collect: [:ea | aServer objectFromJson: ea].
	messageSend := MessageSend
		receiver: receiver
		selector: json selector asSymbol
		arguments: arguments.