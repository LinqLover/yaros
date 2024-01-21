baseline
baseline: spec
	<baseline>

	spec for: #common do: [
		"packages"
		spec package: 'Yaros'.
		
		"groups"
		spec group: #default with: #('Yaros')]