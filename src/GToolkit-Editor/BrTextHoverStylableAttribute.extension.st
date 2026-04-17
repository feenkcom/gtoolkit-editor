Extension { #name : 'BrTextHoverStylableAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextHoverStylableAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	self attributes ifNotEmpty: [ :theAttributes |
		theAttributes first
			asGtExternalTextAttributeForTheme: aTheme
			during: [ :anAttribute |
				GtTextEditorMouseMoveAttribute
					withAttributeOnHover: anAttribute
					during: aBlock ] ]
]
