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
GtTextEditorCompletionDummySettings >> completionMaxHeight: aNumber [
	completionMaxHeight := aNumber
]

{ #category : 'settings' }
GtTextEditorCompletionDummySettings >> completionMaxHeightOrNil [
	^ completionMaxHeight
]

{ #category : 'settings' }
GtTextEditorCompletionDummySettings >> completionWidth: aNumber [
	completionWidth := aNumber
]

{ #category : 'settings' }
GtTextEditorCompletionDummySettings >> completionWidthOrNil [
	^ completionWidth
]
