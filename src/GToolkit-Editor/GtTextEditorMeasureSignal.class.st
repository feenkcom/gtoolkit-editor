Class {
	#name : 'GtTextEditorMeasureSignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'measurementSpec'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorMeasureSignal >> measurementSpec [
	^ measurementSpec
]

{ #category : 'accessing' }
GtTextEditorMeasureSignal >> measurementSpec: anObject [
	measurementSpec := anObject
]

{ #category : 'as yet unclassified' }
GtTextEditorMeasureSignal >> printOneLineContentsOn: aStream [
	aStream nextPutAll: 'Measure '.
	self measurementSpec printRoundedOn: aStream
]
