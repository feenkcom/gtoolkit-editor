Extension { #name : 'BlTextBackgroundAttribute' }

{ #category : '*GToolkit-Editor' }
BlTextBackgroundAttribute >> asGtExternalTextAttributeForTheme: aBlTheme during: aBlock [

	^ GtTextEditorAttribute
		background: (self paint blocResolveColorForTheme: aBlTheme)
		during: aBlock
]
