Class {
	#name : 'GtTextEditorInvisibleMarkerAttribute',
	#superclass : 'GtTextEditorAttribute',
	#instVars : [
		'markerAttribute'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorInvisibleMarkerAttribute >> asAttribute [
	^ self
]

{ #category : 'as yet unclassified' }
GtTextEditorInvisibleMarkerAttribute >> asGtExternalTextAttributeDuring: aBlock [
	^ aBlock value: self
]

{ #category : 'testing' }
GtTextEditorInvisibleMarkerAttribute >> isMarkerAttribute [
	^ true
]

{ #category : 'accessing' }
GtTextEditorInvisibleMarkerAttribute >> markerAttribute [
	^ markerAttribute
]

{ #category : 'accessing' }
GtTextEditorInvisibleMarkerAttribute >> markerAttribute: anObject [
	markerAttribute := anObject
]
