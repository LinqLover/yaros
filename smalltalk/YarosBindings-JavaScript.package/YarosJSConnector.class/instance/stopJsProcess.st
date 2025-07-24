private
stopJsProcess

	jsProcess ifNotNil:
		[jsProcess processProxy terminate.
		jsProcess := nil].
	actualServerPort := nil.