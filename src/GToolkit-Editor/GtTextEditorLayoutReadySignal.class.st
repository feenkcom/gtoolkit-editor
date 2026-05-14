Class {
	#name : 'GtTextEditorLayoutReadySignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'newMeasuredExtent',
		'previousMeasuredExtent'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorLayoutReadySignal >> newMeasuredExtent [
	^ newMeasuredExtent
]

{ #category : 'accessing' }
GtTextEditorLayoutReadySignal >> newMeasuredExtent: anObject [
	newMeasuredExtent := anObject
]

{ #category : 'accessing' }
GtTextEditorLayoutReadySignal >> previousMeasuredExtent [
	^ previousMeasuredExtent
]

{ #category : 'accessing' }
GtTextEditorLayoutReadySignal >> previousMeasuredExtent: anObject [
	previousMeasuredExtent := anObject
]

{ #category : 'as yet unclassified' }
GtTextEditorLayoutReadySignal >> printOneLineContentsOn: aStream [
	(self newMeasuredExtent closeTo: self previousMeasuredExtent)
		ifTrue: [
			aStream
				nextPutAll: 'Extent = ';
				nextPutAll: self newMeasuredExtent rounded printString;
				space. ]
		ifFalse: [
			aStream
				nextPutAll: 'Extent changed ';
				nextPutAll: self previousMeasuredExtent rounded printString;
				nextPutAll: ' -> ';
				nextPutAll: self newMeasuredExtent rounded printString;
				space. ]
]
