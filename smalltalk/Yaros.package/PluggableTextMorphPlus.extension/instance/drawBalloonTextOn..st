*Yaros-drawing-override
drawBalloonTextOn: aCanvas 
	"Show balloon text in the text morph if it has no contents. Catch errors to guard against broken models."

	| helpText helpFont helpColor box |
	self flag: #(workaround yaros). "avoid non-local return"
	textMorph contents "ifNotEmpty:"isEmpty ifFalse: [ ^ self ].
	helpText := [ self balloonText ] on: Error do: [ :err | '<error in #balloonText>' ].
	helpText ifNil: [ ^ self ].
	
	helpFont := self textMorph textStyle defaultFont.
	"self userInterfaceTheme balloonTextFont ifNil: [TextStyle defaultFont]."
	helpColor := self userInterfaceTheme balloonTextColor ifNil: [Color gray: 0.7].
	
	box := self innerBounds insetBy: (self textMorph margins ifNil: [0]).
	box := box insetBy: (0 @ helpFont lineGapSlice corner: 0@0).
	
	aCanvas drawString: helpText in: box font: helpFont color: helpColor.