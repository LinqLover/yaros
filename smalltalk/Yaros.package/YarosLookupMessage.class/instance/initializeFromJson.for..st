initialize-release
initializeFromJson: json for: aServer

	super initializeFromJson: json for: aServer.
	
	name := aServer objectFromJson: json name.