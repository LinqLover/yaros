*YarosBindings-SqueakJS-evaluating-pseudo-override
asyncValue
	"Evaluate the receiver in an asynchronous context where Promises can be #await'ed. Answer a Promise that will be fulfilled or rejected later.
	
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

	| resolve reject finalResult |
	resolve := reject := nil.
	finalResult := self
		on: PromiseAwait do: [:ex |
			| nextPromise makeHandlers |
			nextPromise := Promise new.
			makeHandlers :=
				[| ctxt |
				ctxt := thisContext sender sender.
				resolve := [:value | "resolve := nil." nextPromise resolveWith: value. thisContext swapSender: ctxt].
				reject := [:value | "reject := nil." nextPromise rejectWith: value. thisContext swapSender: ctxt]].
			ex privHandlerContext reactivateHandler.
			thisContext swapSender: thisContext home sender.
			ex promise
				then: [:result |
					makeHandlers value.
					ex resume: result]
				ifRejected: [:error |
					makeHandlers value.
					ex resignalAs: (BrokenPromise new promise: ex promise)].
			resolve ifNotNil: [resolve value: nextPromise].
			nextPromise]
		on: Error do: [:ex |
			reject ifNotNil: [reject value: ex].
			ex pass].
	
	resolve ifNotNil: [resolve value: finalResult].
	^ finalResult asPromise