baseline
baseline: spec
	<baseline>

	spec for: #common do: [
		"packages"
		spec package: 'Yaros'.
		spec package: 'YarosBindings-SqueakJS'.
		
		"groups"
		spec group: #default with: #('Yaros').
		spec group: #squeakJS with: #('Yaros' 'YarosBindings-SqueakJS')]