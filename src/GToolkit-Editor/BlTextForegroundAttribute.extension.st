Extension { #name : 'BlTextForegroundAttribute' }

{ #category : '*GToolkit-Editor' }
BlTextForegroundAttribute >> asGtExternalTextAttributeForTheme: aBlTheme during: aBlock [

	^ GtTextEditorAttribute
		foreground: (self paint blocResolveColorForTheme: aBlTheme)
		during: aBlock
]
