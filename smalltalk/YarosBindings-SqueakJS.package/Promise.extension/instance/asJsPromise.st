*YarosBindings-SqueakJS-*JSBridge-Core-converting-pseudo-override
asJsPromise

	^ JS Promise new: [:resolve :reject |
		self
			then: [:value | resolve call: nil with: value]
			ifRejected: [:error | reject call: nil with: error]]