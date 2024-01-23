instance creation
remoteName: remoteName clientPort: clientPort serverPort: serverPort

	^ self new
		remoteName: remoteName;
		clientPort: clientPort;
		serverPort: serverPort;
		yourself