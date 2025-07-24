baseline
baseline: spec
	<baseline>

	spec for: #common do: [
		"dependencies"
		spec
			package: 'CommandShell' with: [
				spec
					repository: 'https://www.squeaksource.com/CommandShell'];
			baseline: 'SqueakJS' with:
				[spec
					loads: 'JSBridge-Core';
					repository: 'github://LinqLover/SqueakJS:stream--yaros/utils'].
		
		"packages"
		spec package: 'Yaros'.
		spec package: 'YarosBindings-JavaScript' with:
			[spec requires: 'CommandShell'].
		spec package: 'YarosBindings-SqueakJS' with:
			[spec requires: 'SqueakJS'].
		
		"groups"
		spec group: #default with: #('Yaros').
		spec group: #js with: #('Yaros' 'YarosBindings-JavaScript').
		spec group: #squeakJS with: #('Yaros' 'YarosBindings-SqueakJS')]