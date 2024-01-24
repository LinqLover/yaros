*YarosBindings-SqueakJS-*JSBridge-Core-priv handling-pseudo-override-override
defaultAction

	(Smalltalk at: #JS ifAbsent: []) ifNotNil: [:js |
		^ js await: self promise asJsPromise].
	
	^ self error: 'await outside of async context'