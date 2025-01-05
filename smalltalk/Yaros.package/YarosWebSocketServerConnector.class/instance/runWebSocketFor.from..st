private
runWebSocketFor: aWebRequest from: inputStream

	| socket pingProcess |
	socket := aWebRequest asWebSocket.
	socket onMessage: [:data |
		inputStream nextPut: data].
	
	mutex critical:
		[sockets add: socket].
	pingProcess := self startPingPongOn: socket named:
		('{1}''s heartbeat for {2}' format: {self. socket}).
	
	socket onClose:
		[mutex critical:
			[sockets remove: socket.
			pingProcess terminate]].
	
	socket run.