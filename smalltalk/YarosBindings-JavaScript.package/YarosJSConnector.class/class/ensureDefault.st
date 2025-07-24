accessing
ensureDefault

	Default ifNil: [Default := self newNamed: #JS].
	Default ensureRunning.
	Smalltalk at: #JS put: Default yaros js.
	^ Default
	