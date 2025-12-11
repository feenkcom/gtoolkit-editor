Extension { #name : 'String' }

{ #category : '*GToolkit-Editor' }
String >> asGtTextEditorTextForTheme: aTheme during: aBlock [
	^ GtTextEditorExternalText
		fromString: self
		during: aBlock
]
