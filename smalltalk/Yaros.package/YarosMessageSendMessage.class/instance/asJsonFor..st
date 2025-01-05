converting
asJsonFor: aServer

	^ (super asJsonFor: aServer)
		receiver: (aServer jsonForObject: self messageSend receiver);
		selector: self messageSend selector;
		arguments: (self messageSend arguments collect: [:ea | aServer jsonForObject: ea]);
		yourself