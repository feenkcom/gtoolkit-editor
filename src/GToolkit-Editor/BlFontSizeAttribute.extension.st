Extension { #name : 'BlFontSizeAttribute' }

{ #category : '*GToolkit-Editor' }
BlFontSizeAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute fontSize: size during: aBlock
]
