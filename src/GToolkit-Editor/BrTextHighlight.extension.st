Extension { #name : 'BrTextHighlight' }

{ #category : '*GToolkit-Editor' }
BrTextHighlight >> asGtExternalTextHighlightForTheme: aBlTheme during: aBlock [
	^ GtTextEditorHighlight
		id: self id
		color: (self color blocResolveColorForTheme: aBlTheme)
		during: aBlock
]
