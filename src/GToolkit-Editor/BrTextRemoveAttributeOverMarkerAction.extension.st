Extension { #name : 'BrTextRemoveAttributeOverMarkerAction' }

{ #category : '*GToolkit-Editor' }
BrTextRemoveAttributeOverMarkerAction >> asGtTextEditorEventHandlingAction: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ attribute
		gtEditorAsExternalTextAttribute: anAttributesRegistry
		forTheme: aTheme
		during: [ :anExternalAttribute | 
			markerAttribute
				gtEditorAsExternalTextAttribute: anAttributesRegistry
				forTheme: aTheme
				during: [ :aMarkerExternalAttribute | 
					GtTextEditorEventHandlingAction
						removeAttribute: anExternalAttribute attributeTag
						overMarker: aMarkerExternalAttribute attributeTag
						during: aBlock ] ]
]
