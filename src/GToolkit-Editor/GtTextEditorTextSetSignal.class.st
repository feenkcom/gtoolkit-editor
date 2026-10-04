"
I am emitted when a new text is set on the editor element, which is where new documents enter.

Tracking document ids across a run means knowing where each one came from, and every unstyled text handed to the editor starts one.
"
Class {
	#name : 'GtTextEditorTextSetSignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'element',
		'sourceDocumentId',
		'sourceTextSize',
		'targetDocumentId'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> documentId [
	^ self sourceDocumentId
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> documentId: anObject [
	self sourceDocumentId: anObject
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> element [
	^ element
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> element: anObject [
	element := anObject
]

{ #category : 'printing' }
GtTextEditorTextSetSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPutAll: 'Text set, size ';
		print: sourceTextSize;
		nextPutAll: ', ';
		print: sourceDocumentId;
		space
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> sourceDocumentId [
	^ sourceDocumentId
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> sourceDocumentId: anObject [
	sourceDocumentId := anObject
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> sourceTextSize [
	^ sourceTextSize
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> sourceTextSize: anObject [
	sourceTextSize := anObject
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> targetDocumentId [
	^ targetDocumentId
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> targetDocumentId: anObject [
	targetDocumentId := anObject
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> textSize [
	^ self sourceTextSize
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> textSize: anObject [
	self sourceTextSize: anObject
]
