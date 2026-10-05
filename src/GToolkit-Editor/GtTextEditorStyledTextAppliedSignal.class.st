"
I am emitted when the embedder hands a styled text back to the rust editor.

I carry the `documentId` the styled text was computed for. The rust editor discards the text when that id no longer matches its own, so seeing me is not the same as the styling having been applied.

I am the counterpart of ${class:GtTextEditorStylingRequestedSignal}$.
"
Class {
	#name : 'GtTextEditorStyledTextAppliedSignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'element',
		'documentId',
		'textSize'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorStyledTextAppliedSignal >> documentId [
	^ documentId
]

{ #category : 'accessing' }
GtTextEditorStyledTextAppliedSignal >> documentId: anObject [
	documentId := anObject
]

{ #category : 'accessing' }
GtTextEditorStyledTextAppliedSignal >> element [
	^ element
]

{ #category : 'accessing' }
GtTextEditorStyledTextAppliedSignal >> element: anObject [
	element := anObject
]

{ #category : 'printing' }
GtTextEditorStyledTextAppliedSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPutAll: 'Styled text sent for ';
		nextPutAll: documentId printString;
		nextPutAll: ' size ';
		nextPutAll: textSize printString;
		space
]

{ #category : 'accessing' }
GtTextEditorStyledTextAppliedSignal >> textSize [
	^ textSize
]

{ #category : 'accessing' }
GtTextEditorStyledTextAppliedSignal >> textSize: anObject [
	textSize := anObject
]
