initialize-release
initializeFromJson: json for: aServer

	super initializeFromJson: json for: aServer.
	
	error := aServer objectFromJson: (json at: #error).
	result := aServer objectFromJson: json result.