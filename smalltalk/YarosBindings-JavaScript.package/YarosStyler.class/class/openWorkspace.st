examples
openWorkspace

	| workspace |
	workspace := Workspace new.
	workspace contents: self exampleSource.
	workspace shouldStyle: true.
	ToolBuilder open: workspace.
	workspace codeTextPane styler: (self new view: workspace codeTextPane); yourself.
	workspace codeTextPane updateStyle.
	^ workspace