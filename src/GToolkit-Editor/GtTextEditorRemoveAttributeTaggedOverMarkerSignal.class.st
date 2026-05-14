Class {
	#name : 'GtTextEditorRemoveAttributeTaggedOverMarkerSignal',
	#superclass : 'GtTextEditorAttributeSignal',
	#instVars : [
		'attributeTag',
		'markerAttribute',
		'markerTag'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorRemoveAttributeTaggedOverMarkerSignal >> attributeTag [
	^ attributeTag
]

{ #category : 'accessing' }
GtTextEditorRemoveAttributeTaggedOverMarkerSignal >> attributeTag: anObject [
	attributeTag := anObject
]

{ #category : 'accessing' }
GtTextEditorRemoveAttributeTaggedOverMarkerSignal >> markerAttribute [
	^ markerAttribute
]

{ #category : 'accessing' }
GtTextEditorRemoveAttributeTaggedOverMarkerSignal >> markerAttribute: anObject [
	markerAttribute := anObject
]

{ #category : 'accessing' }
GtTextEditorRemoveAttributeTaggedOverMarkerSignal >> markerTag [
	^ markerTag
]

{ #category : 'accessing' }
GtTextEditorRemoveAttributeTaggedOverMarkerSignal >> markerTag: anObject [
	markerTag := anObject
]

{ #category : 'printing' }
GtTextEditorRemoveAttributeTaggedOverMarkerSignal >> printOneLineContentsOn: stream [
	stream
		nextPutAll: '- ';
		print: attributeTag;
		nextPutAll: ' over ';
		print: markerTag;
		space.
	markerAttribute gtDisplayOn: stream
]
