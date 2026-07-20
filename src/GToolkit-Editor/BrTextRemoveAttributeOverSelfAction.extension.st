Extension { #name : 'BrTextRemoveAttributeOverSelfAction' }

{ #category : '*GToolkit-Editor' }
BrTextRemoveAttributeOverSelfAction >> asGtTextEditorEventHandlingAction: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ attribute
		gtEditorAsExternalTextAttribute: anAttributesRegistry
		forTheme: aTheme
		during: [ :anExternalAttribute | 
			GtTextEditorEventHandlingAction
				removeAttributeOverSelf: anExternalAttribute attributeTag
				during: aBlock ]
]
