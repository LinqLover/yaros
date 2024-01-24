baseline
baseline: spec
	<baseline>

	spec for: #common do: [
		"dependencies"
		spec baseline: 'SqueakJS' with:
			[spec
				loads: 'JSBridge-Core';
				repository: 'github://LinqLover/SqueakJS:stream--jaros/utils'].
		
		"packages"
		spec package: 'Yaros'.
		spec package: 'YarosBindings-SqueakJS' with:
			[spec requires: 'SqueakJS'].
		
		"groups"
		spec group: #default with: #('Yaros').
		spec group: #squeakJS with: #('Yaros' 'YarosBindings-SqueakJS')]