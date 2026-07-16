Extension { #name : 'BlFontWeightAttribute' }

{ #category : '*GToolkit-Editor' }
BlFontWeightAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute fontWeight: weight during: aBlock
]
