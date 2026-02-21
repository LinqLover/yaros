*Yaros-proxies-copying-override
copyBits
	"Primitive. Perform the movement of bits from the source form to the 
	destination form. Fail if any variables are not of the right type (Integer, 
	Float, or Form) or if the combination rule is not implemented. 

	NOTE THAT this method has the side effect of showing the copied bits on
	screen if the destination form happens to be Display. The mechanism is
	similar to calling #primShowRectLeft:right:top:bottom: manually.

	In addition to the original 16 combination rules, this BitBlt supports
	16	fail (to simulate paint)
	17	fail (to simulate mask)
	18	sourceWord + destinationWord
	19	sourceWord - destinationWord
	20	rgbAdd: sourceWord with: destinationWord
	21	rgbSub: sourceWord with: destinationWord
	22	rgbDiff: sourceWord with: destinationWord
	23	tallyIntoMap: destinationWord
	24	alphaBlend: sourceWord with: destinationWord
	25	pixPaint: sourceWord with: destinationWord
	26	pixMask: sourceWord with: destinationWord
	27	rgbMax: sourceWord with: destinationWord
	28	rgbMin: sourceWord with: destinationWord
	29	rgbMin: sourceWord bitInvert32 with: destinationWord
"
	<primitive: 'primitiveCopyBits' module: 'BitBltPlugin' error: ec>

	(combinationRule >= 30 and: [combinationRule <= 31]) ifTrue:
		["No alpha specified -- re-run with alpha = 1.0"
		^ self copyBitsTranslucent: 255].
	"Check for object movement during a surface callback, compressed source, destination or halftone forms.
	 Simply retry."
	(ec == #'object moved'
	 or: [(sourceForm isForm and: [sourceForm unhibernate])
	 or: [(destForm isForm and: [destForm unhibernate])
	 or: [halftoneForm isForm and: [halftoneForm unhibernate]]]]) ifTrue:
		[^self copyBits].

	"Check for unimplmented rules"
	combinationRule = Form oldPaint ifTrue: [^self paintBits].
	combinationRule = Form oldErase1bitShape ifTrue: [^self eraseBits].

	"Check if BitBlt doesn't support full color maps"
	(colorMap notNil and: [colorMap isColormap]) ifTrue:
		[colorMap := colorMap colors.
		^self copyBits].
	
	destForm isProxy ifTrue: "?"
		[destForm := destForm resolveProxy.
		^self copyBits].
	destForm width isProxy ifTrue:
		[destForm instVarNamed: 'width' put: destForm width resolveProxy.
		^self copyBits].
	destForm height isProxy ifTrue:
		[destForm instVarNamed: 'height' put: destForm height resolveProxy.
		^self copyBits].
	destForm bits isProxy ifTrue:
		[destForm instVarNamed: 'bits' put: (destForm instVarNamed: 'bits') resolveProxy.
		^self copyBits].
	self flag: #ct. "If a proxy looks like a Form or color map (begins with compatible instance variables), we ought to test proxies *before* executing the primitive. However this situation has not yet occurred and the current way is easier."
	sourceForm isProxy ifTrue:
		[sourceForm := sourceForm resolveProxy.
		^self copyBits].
	sourceForm ifNotNil:
		[sourceForm bits isProxy ifTrue:
			[sourceForm instVarNamed: 'bits' put: (sourceForm instVarNamed: 'bits') resolveProxy.
			sourceForm width isProxy ifTrue:
				[sourceForm instVarNamed: 'width' put: sourceForm width resolveProxy].
			sourceForm height isProxy ifTrue:
				[sourceForm instVarNamed: 'height' put: sourceForm height resolveProxy].
			sourceForm depth isProxy ifTrue:
				[sourceForm instVarNamed: 'depth' put: sourceForm depth resolveProxy].
			(sourceForm instVarNamed: 'offset') isProxy ifTrue:
				[sourceForm instVarNamed: 'offset' put: (sourceForm instVarNamed: 'offset') resolveProxy].
			^self copyBits]].
	halftoneForm isProxy ifTrue:
		[halftoneForm := halftoneForm resolveProxy.
		^self copyBits].
	combinationRule isProxy ifTrue:
		[combinationRule := combinationRule resolveProxy.
		^self copyBits].
	colorMap isProxy ifTrue:
		[colorMap := colorMap resolveProxy.
		^self copyBits].
	destX isProxy ifTrue:
		[destX := destX resolveProxy.
		^ self copyBits].
	destY isProxy ifTrue:
		[destY := destY resolveProxy.
		^ self copyBits].
	width isProxy ifTrue:
		[width := width resolveProxy.
		^ self copyBits].
	height isProxy ifTrue:
		[height := height resolveProxy.
		^ self copyBits].
	sourceX isProxy ifTrue:
		[sourceX := sourceX resolveProxy.
		^ self copyBits].
	sourceY isProxy ifTrue:
		[sourceY := sourceY resolveProxy.
		^ self copyBits].
	clipX isProxy ifTrue:
		[clipX := clipX resolveProxy.
		^ self copyBits].
	clipY isProxy ifTrue:
		[clipY := clipY resolveProxy.
		^ self copyBits].
	clipWidth isProxy ifTrue:
		[clipWidth := clipWidth resolveProxy.
		^ self copyBits].
	clipHeight isProxy ifTrue:
		[clipHeight := clipHeight resolveProxy.
		^ self copyBits].
	
	"Check if clipping got way out of range"
	self clipRange.
	"Convert all numeric parameters to integers and try again."
	self roundVariables.
	^self copyBitsAgain