"
I am emitted when the rust editor tells the embedder that it discarded a styled text for targeting a stale document.

I put the rejection on the same timeline as ${class:GtTextEditorStylingRequestedSignal}$ and ${class:GtTextEditorStyledTextAppliedSignal}$, so that a styling round that produced nothing can be told apart from one that was never requested.
"
Class {
	#name : 'GtTextEditorStyledTextRejectedSignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'element',
		'expectedDocumentId',
		'receivedDocumentId'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorStyledTextRejectedSignal >> element [
	^ element
]

{ #category : 'accessing' }
GtTextEditorStyledTextRejectedSignal >> element: anObject [
	element := anObject
]

{ #category : 'accessing' }
GtTextEditorStyledTextRejectedSignal >> expectedDocumentId [
	^ expectedDocumentId
]

{ #category : 'accessing' }
GtTextEditorStyledTextRejectedSignal >> expectedDocumentId: anObject [
	expectedDocumentId := anObject
]

{ #category : 'printing' }
GtTextEditorStyledTextRejectedSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPutAll: 'Styled text rejected, editor had ';
		nextPutAll: expectedDocumentId printString;
		nextPutAll: ' but received ';
		nextPutAll: receivedDocumentId printString;
		space
]

{ #category : 'accessing' }
GtTextEditorStyledTextRejectedSignal >> receivedDocumentId [
	^ receivedDocumentId
]

{ #category : 'accessing' }
GtTextEditorStyledTextRejectedSignal >> receivedDocumentId: anObject [
	receivedDocumentId := anObject
]
