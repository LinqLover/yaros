control
stop

	self triggerEvent: #aboutToStop.
	self
		stopClient;
		stopServer.
	self triggerEvent: #stopped.