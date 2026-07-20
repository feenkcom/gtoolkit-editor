Extension { #name : 'BrTextAddAttributeOverMarkerAction' }

{ #category : '*GToolkit-Editor' }
BrTextAddAttributeOverMarkerAction >> asGtTextEditorEventHandlingAction: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ attribute
		gtEditorAsExternalTextAttribute: anAttributesRegistry
		forTheme: aTheme
		during: [ :anExternalAttribute | 
			markerAttribute
				gtEditorAsExternalTextAttribute: anAttributesRegistry
				forTheme: aTheme
				during: [ :aMarkerExternalAttribute | 
					GtTextEditorEventHandlingAction
						addAttribute: anExternalAttribute
						overMarker: aMarkerExternalAttribute attributeTag
						during: aBlock ] ]
]
