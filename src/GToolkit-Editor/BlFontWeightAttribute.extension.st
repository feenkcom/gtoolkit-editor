Extension { #name : 'BlFontWeightAttribute' }

{ #category : '*GToolkit-Editor' }
BlFontWeightAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute fontWeight: weight during: aBlock
]
