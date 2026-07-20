Extension { #name : 'BrTextAddAttributeOverSelfLastCharsAction' }

{ #category : '*GToolkit-Editor' }
BrTextAddAttributeOverSelfLastCharsAction >> asGtTextEditorEventHandlingAction: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ attribute
		gtEditorAsExternalTextAttribute: anAttributesRegistry
		forTheme: aTheme
		during: [ :anExternalAttribute | 
			GtTextEditorEventHandlingAction
				addAttributeOverSelf: anExternalAttribute
				lastCharacters: charCount
				during: aBlock ]
]
