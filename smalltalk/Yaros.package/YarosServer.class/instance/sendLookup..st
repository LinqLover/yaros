as yet unclassified
sendLookup: aString

	| json |
	json := self compileLookup: aString.
	self send: json.
	^ json id