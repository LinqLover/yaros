accessing
rangesBlock

	^ rangesBlock ifNil:
		[self runningJsConnector ifNotNil:
			[rangesBlock := self makeRangesBlock.
			self jsConnector yaros when: #aboutToStop send: #resetRangesBlock to: self.
			rangesBlock]]