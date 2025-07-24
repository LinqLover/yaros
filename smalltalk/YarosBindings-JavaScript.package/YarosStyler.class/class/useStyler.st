registration
useStyler
	<preference: 'Use Yaros styler(s)' category: #Yaros description: 'If enabled, use text stylers for additional languages with Yaros'' JavaScript binding and an external library.' type: #Boolean>

	^ UseStyler ifNil: [false]