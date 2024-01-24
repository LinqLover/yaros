*YarosBindings-SqueakJS-*JSBridge-Core-converting-pseudo-override
asSqueakPromise

	^ Promise new
		in: [:promise |
			self
				then: [:value | promise resolveWith: value]
				catch: [:error | promise rejectWith: error]];
		yourself