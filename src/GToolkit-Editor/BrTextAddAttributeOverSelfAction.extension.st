Extension { #name : 'BrTextAddAttributeOverSelfAction' }

{ #category : '*GToolkit-Editor' }
BrTextAddAttributeOverSelfAction >> asGtTextEditorEventHandlingAction: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ attribute
		gtEditorAsExternalTextAttribute: anAttributesRegistry
		forTheme: aTheme
		during: [ :anExternalAttribute | 
			GtTextEditorEventHandlingAction
				addAttributeOverSelf: anExternalAttribute
				during: aBlock ]
]
