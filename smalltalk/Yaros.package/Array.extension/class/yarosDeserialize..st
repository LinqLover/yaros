*Yaros-serializing
yarosDeserialize: proxyArray

	| array |
	array := Array new: proxyArray size.
	proxyArray withIndexDo: [:each :index |
		array at: index put: each].
	^ array