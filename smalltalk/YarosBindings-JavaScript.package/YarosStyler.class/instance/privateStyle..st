private
privateStyle: aText

	| ranges |
	ranges := self rangesIn: aText.
	ranges ifNotNil: [self setAttributesIn: aText fromRanges: ranges].