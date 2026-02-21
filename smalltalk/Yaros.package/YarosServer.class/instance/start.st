control
start

	self
		startClient;
		startServer.
	self triggerEvent: #started.