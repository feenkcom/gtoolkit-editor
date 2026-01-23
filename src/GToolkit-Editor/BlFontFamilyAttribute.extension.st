Extension { #name : 'BlFontFamilyAttribute' }

{ #category : '*GToolkit-Editor' }
BlFontFamilyAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute fontFamily: name during: aBlock
]
