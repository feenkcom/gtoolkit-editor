Extension { #name : 'BrTextAdornmentAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextAdornmentAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	self shouldAppend
		ifTrue: [ ^ GtTextEditorAppendingAttribute newDuring: [ :attribute |
			attribute adornmentAttribute: self.
			aBlock value: attribute ] ].
			
	self shouldReplace
		ifTrue: [ ^ GtTextEditorReplacingAttribute newDuring: [ :attribute |
			attribute adornmentAttribute: self.
			aBlock value: attribute ] ].

	^ self
]
