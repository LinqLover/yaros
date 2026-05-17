*Yaros-container protocol-override
expand

 	| newChildren c |

	(self isExpanded or: [self canExpand not])
		ifTrue: [^ self].
	
	self isExpanded: true.
	
	self flag: #(workaround yaros).
	(c := self getChildren) "ifEmpty:"isEmpty ifTrue: [
		"Due to the guessing in #canExpand, it may still fail here."
		^ self].

	newChildren := container 
		addSubmorphsAfter: self 
		fromCollection: c 
		allowSorting: true.
	container changed. "See mismatch between #removeAllMorphsIn: and #privateAddAllMorphs:atIndex:"

	firstChild := newChildren first.