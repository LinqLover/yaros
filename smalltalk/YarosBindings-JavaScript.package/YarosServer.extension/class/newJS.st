*YarosBindings-JavaScript-instance creation
newJS

	^ self new
		name: 'JS';
		remoteObjectClass: YarosJSRemoteObject;
		yourself