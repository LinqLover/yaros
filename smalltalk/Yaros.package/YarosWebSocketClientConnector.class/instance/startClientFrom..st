control
startClientFrom: inputStream

	| pingProcess |
	webSocket := WebClient webSocket07: self serverUrl protocol: nil.
	webSocket onMessage: [:data |
		inputStream nextPut: data].
	
	pingProcess := self startPingPongOn: webSocket named:
		('{1}''s heartbeat' format: {self}).
	
	webSocket onClose:
		[pingProcess terminate.
		webSocket := nil.
		self stopClient.
		self triggerEvent: #clientStopped].
	
	[webSocket run] forkAt: 30 named: ('{1}''s client' format: {self}).