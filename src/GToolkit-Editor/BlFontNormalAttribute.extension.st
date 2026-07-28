Extension { #name : 'BlFontNormalAttribute' }

{ #category : '*GToolkit-Editor' }
BlFontNormalAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute normalDuring: aBlock
]
