Extension { #name : 'BrTextInvisibleMarkerAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextInvisibleMarkerAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	^ GtTextEditorInvisibleMarkerAttribute
		newDuring: [ :rustAttribute | 
			rustAttribute markerAttribute: self.
			aBlock value: rustAttribute ]
]
