private
findServerPort

	| stream readers homeProcess regex |
	stream := ClosableSharedQueue2 new.
	homeProcess := Processor activeProcess.
	readers :=
		{[jsProcess outputOn: stream].
		 [[1 second wait] doWhileFalse: [jsProcess isComplete].
		  homeProcess signalException: (Error new messageText: jsProcess errorUpToEnd)]}
			collect: [:block | block forkAt: Processor activePriority].
	[regex := 'YarosWebSocketServerConnector listening on ws\://localhost\:(\d+)/comm' asRegex.
	[stream atEnd] whileFalse:
		[(stream nextLine matchesRegex: regex) ifTrue:
			[^ (regex subexpression: 2) asNumber]]]
				ensure:
					[readers do: #terminate].