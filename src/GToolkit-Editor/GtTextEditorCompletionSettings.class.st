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

{ #category : 'settings' }
GtTextEditorCompletionSettings class >> completionMaxHeight [
	^ CompletionMaxHeight ifNil: [ CompletionMaxHeight := 400 ]
]

{ #category : 'settings' }
GtTextEditorCompletionSettings class >> completionMaxHeight: aNumber [
	CompletionMaxHeight := aNumber
]

{ #category : 'settings' }
GtTextEditorCompletionSettings class >> completionWidth [
	^ CompletionWidth ifNil: [ CompletionWidth := 600 ]
]

{ #category : 'settings' }
GtTextEditorCompletionSettings class >> completionWidth: aNumber [
	CompletionWidth := aNumber
]
