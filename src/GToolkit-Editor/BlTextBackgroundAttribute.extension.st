Extension { #name : 'BlTextBackgroundAttribute' }

{ #category : '*GToolkit-Editor' }
BlTextBackgroundAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute
		background: (self paint blocResolveColorForTheme: aTheme)
		during: aBlock
]
