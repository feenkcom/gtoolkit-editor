"
I am emitted when the rust editor asks the embedder to style the current text.

I carry the `documentId` the styling was requested for, which is the id the styled text has to still match when it comes back, and the `trigger` that caused the request.

Pairing me with ${class:GtTextEditorStyledTextAppliedSignal}$ shows how long a styling was in flight and what happened to the editor meanwhile.
"
Class {
	#name : 'GtTextEditorStylingRequestedSignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'element',
		'documentId',
		'trigger',
		'textSize',
		'lastStyledDocumentId'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorStylingRequestedSignal >> documentId [
	^ documentId
]

{ #category : 'accessing' }
GtTextEditorStylingRequestedSignal >> documentId: anObject [
	documentId := anObject
]

{ #category : 'accessing' }
GtTextEditorStylingRequestedSignal >> element [
	^ element
]

{ #category : 'accessing' }
GtTextEditorStylingRequestedSignal >> element: anObject [
	element := anObject
]

{ #category : 'accessing' }
GtTextEditorStylingRequestedSignal >> lastStyledDocumentId [
	"Answer the document of the last styled text the element applied, which is not necessarily
	the document the editor holds now, but is the closest the embedder can observe."
	^ lastStyledDocumentId
]

{ #category : 'accessing' }
GtTextEditorStylingRequestedSignal >> lastStyledDocumentId: anObject [
	lastStyledDocumentId := anObject
]

{ #category : 'printing' }
GtTextEditorStylingRequestedSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPutAll: 'Styling requested for ';
		nextPutAll: documentId printString;
		nextPutAll: ' size ';
		print: textSize;
		nextPutAll: ' trigger ';
		nextPutAll: trigger printString;
		nextPutAll: ' last styled ';
		nextPutAll: lastStyledDocumentId printString;
		space
]

{ #category : 'accessing' }
GtTextEditorStylingRequestedSignal >> textSize [
	"Answer the size of the unstyled text the editor asked to have styled."
	^ textSize
]

{ #category : 'accessing' }
GtTextEditorStylingRequestedSignal >> textSize: anObject [
	textSize := anObject
]

{ #category : 'accessing' }
GtTextEditorStylingRequestedSignal >> trigger [
	^ trigger
]

{ #category : 'accessing' }
GtTextEditorStylingRequestedSignal >> trigger: anObject [
	trigger := anObject
]
