Class {
	#name : 'GtTextEditorAddAttributeOverRangeSignal',
	#superclass : 'GtTextEditorAttributeSignal',
	#instVars : [
		'attribute',
		'attributeTag',
		'range'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorAddAttributeOverRangeSignal >> attribute [
	^ attribute
]

{ #category : 'accessing' }
GtTextEditorAddAttributeOverRangeSignal >> attribute: anObject [
	attribute := anObject
]

{ #category : 'accessing' }
GtTextEditorAddAttributeOverRangeSignal >> attributeTag [
	^ attributeTag
]

{ #category : 'accessing' }
GtTextEditorAddAttributeOverRangeSignal >> attributeTag: anObject [
	attributeTag := anObject
]

{ #category : 'printing' }
GtTextEditorAddAttributeOverRangeSignal >> printOneLineContentsOn: stream [
	stream
		nextPutAll: '+ ';
		print: attributeTag;
		space.
	attribute gtDisplayOn: stream.
	stream nextPutAll: ' over '.
	range gtDisplayOn: stream
]

{ #category : 'accessing' }
GtTextEditorAddAttributeOverRangeSignal >> range [
	^ range
]

{ #category : 'accessing' }
GtTextEditorAddAttributeOverRangeSignal >> range: anObject [
	range := anObject
]
