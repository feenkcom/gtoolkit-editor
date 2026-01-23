Extension { #name : 'BlFontSizeAttribute' }

{ #category : '*GToolkit-Editor' }
BlFontSizeAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute fontSize: size during: aBlock
]
