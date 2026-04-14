Extension { #name : 'BlTextUnderlayAttribute' }

{ #category : '*GToolkit-Editor' }
BlTextUnderlayAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute
		background: (self paint blocResolveColorForTheme: aTheme)
		during: aBlock
]
