Extension { #name : 'BlFontFamilyAttribute' }

{ #category : '*GToolkit-Editor' }
BlFontFamilyAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute fontFamily: name during: aBlock
]
