Extension { #name : 'BrTextInvisibleMarkerAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextInvisibleMarkerAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorInvisibleMarkerAttribute
		newDuring: [ :rustAttribute | 
			rustAttribute markerAttribute: self.
			aBlock value: rustAttribute ]
]
