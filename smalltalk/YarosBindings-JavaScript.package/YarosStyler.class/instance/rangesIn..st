private
rangesIn: aText

	| block ranges |
	block := self rangesBlock ifNil: [^ #()].
	
	ranges := (block value: aText asString) collect: [:tuple |
		SHRange start: tuple first + 1 end: tuple second type: tuple third].
	
	self assert: (ranges allSatisfy: [:ea | ea start > 0 and: [ea end <= aText size]]).
	
	^ ranges