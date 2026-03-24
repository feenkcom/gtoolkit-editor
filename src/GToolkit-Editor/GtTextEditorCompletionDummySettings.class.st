Class {
	#name : 'GtTextEditorCompletionDummySettings',
	#superclass : 'Object',
	#instVars : [
		'completionMaxHeight',
		'completionWidth'
	],
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'settings' }
GtTextEditorCompletionDummySettings >> completionMaxHeight [
	^ completionMaxHeight ifNil: [ completionMaxHeight := 400 ]
]

{ #category : 'settings' }
GtTextEditorCompletionDummySettings >> completionMaxHeight: aNumber [
	completionMaxHeight := aNumber
]

{ #category : 'settings' }
GtTextEditorCompletionDummySettings >> completionWidth [
	^ completionWidth ifNil: [ completionWidth := 600 ]
]

{ #category : 'settings' }
GtTextEditorCompletionDummySettings >> completionWidth: aNumber [
	completionWidth := aNumber
]
