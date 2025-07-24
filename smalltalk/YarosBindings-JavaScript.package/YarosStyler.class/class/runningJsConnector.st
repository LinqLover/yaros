private
runningJsConnector

	JsConnector ifNil: [JsConnector := YarosJSConnector newNamed: thisContext methodClass theNonMetaClassName].
	JsConnector isRunning ifFalse:
		[JsConnector isRestarting ifTrue: [^ nil].
		JsConnector start].
	^ JsConnector