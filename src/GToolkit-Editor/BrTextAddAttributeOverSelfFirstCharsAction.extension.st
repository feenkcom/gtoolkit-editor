Extension { #name : 'BrTextAddAttributeOverSelfFirstCharsAction' }

{ #category : '*GToolkit-Editor' }
BrTextAddAttributeOverSelfFirstCharsAction >> asGtTextEditorEventHandlingAction: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ attribute
		gtEditorAsExternalTextAttribute: anAttributesRegistry
		forTheme: aTheme
		during: [ :anExternalAttribute | 
			GtTextEditorEventHandlingAction
				addAttributeOverSelf: anExternalAttribute
				firstCharacters: charCount
				during: aBlock ]
]
