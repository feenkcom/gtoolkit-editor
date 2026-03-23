Class {
	#name : 'GtCompletionSettings',
	#superclass : 'Object',
	#classVars : [
		'CompletionMaxHeight',
		'CompletionWidth'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'settings' }
GtCompletionSettings class >> completionMaxHeight [
	^ CompletionMaxHeight ifNil: [ CompletionMaxHeight := 400 ]
]

{ #category : 'settings' }
GtCompletionSettings class >> completionMaxHeight: aNumber [
	CompletionMaxHeight := aNumber
]

{ #category : 'settings' }
GtCompletionSettings class >> completionWidth [
	^ CompletionWidth ifNil: [ CompletionWidth := 600 ]
]

{ #category : 'settings' }
GtCompletionSettings class >> completionWidth: aNumber [
	CompletionWidth := aNumber
]
