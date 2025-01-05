instance creation
fromJson: json for: aServer

	| messageClass |
	messageClass := self allSubclasses
		detect: [:class | class type = json type].
	^ messageClass basicNew
		initializeFromJson: json for: aServer