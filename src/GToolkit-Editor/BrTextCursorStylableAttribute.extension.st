Extension { #name : 'BrTextCursorStylableAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextCursorStylableAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	self attributes ifNotEmpty: [ :theAttributes |
		theAttributes first
			gtEditorAsExternalTextAttribute: anAttributesRegistry
			forTheme: aTheme
			during: [ :anAttribute |
				GtTextEditorMouseMoveAttribute
					withAttributeOnHover: anAttribute
					during: aBlock ] ]
]
