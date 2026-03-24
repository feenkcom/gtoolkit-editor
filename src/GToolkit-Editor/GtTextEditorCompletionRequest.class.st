Class {
	#name : 'GtTextEditorCompletionRequest',
	#superclass : 'Object',
	#instVars : [
		'completionStream',
		'byteOffset',
		'documentId'
	],
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'accessing' }
GtTextEditorCompletionRequest >> byteOffset [
	^ byteOffset
]

{ #category : 'accessing' }
GtTextEditorCompletionRequest >> byteOffset: anObject [
	byteOffset := anObject
]

{ #category : 'accessing' }
GtTextEditorCompletionRequest >> completionStream [
	^ completionStream
]

{ #category : 'accessing' }
GtTextEditorCompletionRequest >> completionStream: anObject [
	completionStream := anObject
]

{ #category : 'accessing' }
GtTextEditorCompletionRequest >> documentId [
	^ documentId
]

{ #category : 'accessing' }
GtTextEditorCompletionRequest >> documentId: anObject [
	documentId := anObject
]
