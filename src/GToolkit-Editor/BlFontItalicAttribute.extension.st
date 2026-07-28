Extension { #name : 'BlFontItalicAttribute' }

{ #category : '*GToolkit-Editor' }
BlFontItalicAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute italicDuring: aBlock
]
