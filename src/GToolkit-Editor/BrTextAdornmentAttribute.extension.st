Extension { #name : 'BrTextAdornmentAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextAdornmentAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	^ GtTextEditorAdornmentAttribute newDuring: [ :attribute |
		attribute adornmentAttribute: self.
		self shouldAppend
			ifTrue: [ attribute beAppend ].
		self shouldReplace
			ifTrue: [ attribute beReplace ].
		aBlock value: attribute ]
]
