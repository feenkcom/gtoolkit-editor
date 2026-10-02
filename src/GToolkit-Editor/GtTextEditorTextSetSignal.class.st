"
I am emitted when a new text is set on the editor element, which is where new documents enter.

Tracking document ids across a run means knowing where each one came from, and every unstyled text handed to the editor starts one.
"
Class {
	#name : 'GtTextEditorTextSetSignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'element',
		'textSize',
		'documentId'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> documentId [
	^ documentId
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> documentId: anObject [
	documentId := anObject
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
		print: textSize;
		nextPutAll: ', ';
		print: documentId;
		space
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> textSize [
	^ textSize
]

{ #category : 'accessing' }
GtTextEditorTextSetSignal >> textSize: anObject [
	textSize := anObject
]
