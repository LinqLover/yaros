initialize-release
cleanUp: aggressive

	JsConnector ifNotNil: [JsConnector stop. JsConnector := nil].