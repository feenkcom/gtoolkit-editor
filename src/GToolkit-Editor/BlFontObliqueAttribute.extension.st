Extension { #name : 'BlFontObliqueAttribute' }

{ #category : '*GToolkit-Editor' }
BlFontObliqueAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute obliqueDuring: aBlock
]
