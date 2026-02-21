proxies
resolveProxy

	^ (Smalltalk classNamed: (self perform: #class) name) yarosDeserialize: self yarosSerialize