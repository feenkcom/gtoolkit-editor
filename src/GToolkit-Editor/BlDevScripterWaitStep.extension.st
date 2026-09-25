Extension { #name : 'BlDevScripterWaitStep' }

{ #category : '*GToolkit-Editor' }
BlDevScripterWaitStep >> waitRustEditorRendered: anElement pulseDuring: aDuration [
	self
		label: ('Wait for rust editor to be rendered while pulsing with {1} timeout'
				format: {aDuration humanReadablePrintString}).
	self onSpace.
	self
		waitingBlock: [ :aSpace | 
			| aStartTime aSemaphore aLastResult |
			aSemaphore := Semaphore new.
			anElement privateRequestEditorAction: [ :aMessage | aSemaphore signal ].
			aStartTime := aSpace time now.
			aSpace time
				every: 100 milliSeconds
				while: [ (timeIsOk := aSpace time now < (aStartTime + aDuration))
						and: [ aLastResult := aSemaphore isSignaled.
							aLastResult not ] ]
				do: [ aSpace pulse.
					self increaseCycle ].
			self
				assert: aLastResult
				description: [ 'Rust editor was not rendered within {1}: {2}'
						format: {aDuration humanReadablePrintString}.
					anElement ] ]
]
