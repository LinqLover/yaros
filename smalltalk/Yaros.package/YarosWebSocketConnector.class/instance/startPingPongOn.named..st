private
startPingPongOn: aWebSocket named: aString

	| interval pingProcess pingSemaphore timeout |
	interval := 1 seconds.
	timeout := 30 seconds.
	
	pingSemaphore := Semaphore new.
	pingProcess :=
		[[aWebSocket ping: DateAndTime millisecondClock asString.
		[pingSemaphore wait] valueWithin: timeout onTimeout:
			[aWebSocket close].
		interval wait]
			repeat]
				forkAt: 30 named: aString.
	
	aWebSocket onPong: [:data |
		pingSemaphore signal].
	
	^ pingProcess