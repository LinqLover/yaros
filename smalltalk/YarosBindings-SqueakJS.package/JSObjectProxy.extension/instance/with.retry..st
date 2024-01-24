*YarosBindings-SqueakJS-private-override
with: argument retry: retryBlock
	| error |
	(error := self primGetError) ifNil: [^ self error: 'JSBridge error'].
	(error beginsWith: 'asJSArgument') ifTrue: [
		"<-- Yaros proxies"
		argument isProxy ifTrue: [^retryBlock value: argument resolveProxyArray].
		argument isCollection ifTrue: [
			argument withIndexDo: [:ea :index |
				argument isProxy ifTrue: [
					^retryBlock value: (argument copy at: index put: ea resolveProxy; yourself)]]].
		"<--"
		^retryBlock value: argument asJSArgument].
	(error beginsWith: 'CallbackSemaphore') ifTrue: [
		self class initCallbacks.
		^retryBlock value: argument].
	self error: error.
