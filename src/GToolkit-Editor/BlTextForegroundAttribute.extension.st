Extension { #name : 'BlTextForegroundAttribute' }

{ #category : '*GToolkit-Editor' }
BlTextForegroundAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute
		foreground: (self paint blocResolveColorForTheme: aTheme)
		during: aBlock
]
