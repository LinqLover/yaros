signaling
signalFor: aPromise

	^ self new
		promise: aPromise;
		signal