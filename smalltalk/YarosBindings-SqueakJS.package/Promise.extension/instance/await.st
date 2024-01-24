*YarosBindings-SqueakJS-waiting-pseudo-override
await
	"Wait asynchronously wait for the receiver to become fulfilled or rejected. If the receiver was fulfilled, answer the resolved value, if it was rejected, signal a BrokenPromise error. #async can only be sent in an asynchronous context. See BlockClosure>>asyncValue.
	
	Examples:
		[42] asyncValue
		[(Promise unit: 42) await] asyncValue
		[Promise new in: [:p | (p future: 5000) resolveWith: 42]; await] asyncValue
		[Promise new in: [:p | (p future: 3000) rejectWith: 17]; await] asyncValue
		[[Promise new in: [:p | (p future: 1000) rejectWith: 17]; await]
				on: BrokenPromise do: [].
			Promise new in: [:p | (p future: 1000) resolveWith: 42]; await]
				asyncValue
		[[Promise new in: [:p | (p future: 1000) rejectWith: 17]; await]
				on: BrokenPromise do: [].
			(Promise unit: 42) halt await]
				asyncValue
	
	TODO: fix bugs & write tests"

	^ PromiseAwait signalFor: self