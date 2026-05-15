Class {
	#name : 'GtTextEditorCompletionSettings',
	#superclass : 'Object',
	#classVars : [
		'CompletionMaxHeight',
		'CompletionWidth'
	],
	#category : 'GToolkit-Editor-Completion',
	#package : 'GToolkit-Editor',
	#tag : 'Completion'
}

{ #category : 'cleanup' }
GtTextEditorCompletionSettings class >> cleanUp [
	CompletionMaxHeight := nil.
	CompletionWidth := nil
]

{ #category : 'settings' }
GtTextEditorCompletionSettings class >> completionMaxHeight: aNumber [
	CompletionMaxHeight := aNumber
]

{ #category : 'settings' }
GtTextEditorCompletionSettings class >> completionMaxHeightOrNil [
	^ CompletionMaxHeight
]

{ #category : 'settings' }
GtTextEditorCompletionSettings class >> completionWidth: aNumber [
	CompletionWidth := aNumber
]

{ #category : 'settings' }
GtTextEditorCompletionSettings class >> completionWidthOrNil [
	^ CompletionWidth
]
