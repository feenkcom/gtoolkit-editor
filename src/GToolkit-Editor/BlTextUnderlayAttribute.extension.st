Extension { #name : 'BlTextUnderlayAttribute' }

{ #category : '*GToolkit-Editor' }
BlTextUnderlayAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute
		background: (self paint blocResolveColorForTheme: aTheme)
		during: aBlock
]
