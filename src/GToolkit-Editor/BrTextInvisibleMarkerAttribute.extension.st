Extension { #name : 'BrTextInvisibleMarkerAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextInvisibleMarkerAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute
		markerDuring: [ :rustAttribute | 
			rustAttribute markerAttribute: self.
			aBlock value: rustAttribute ]
]
