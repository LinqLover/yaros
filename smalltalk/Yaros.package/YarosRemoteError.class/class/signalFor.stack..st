signaling
signalFor: anException stack: stack

	^ self new
		exception: anException;
		stack: stack;
		signal