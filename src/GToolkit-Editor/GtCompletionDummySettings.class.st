Class {
	#name : 'GtCompletionDummySettings',
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
GtCompletionDummySettings >> completionMaxHeight [
	^ completionMaxHeight ifNil: [ completionMaxHeight := 400 ]
]

{ #category : 'settings' }
GtCompletionDummySettings >> completionMaxHeight: aNumber [
	completionMaxHeight := aNumber
]

{ #category : 'settings' }
GtCompletionDummySettings >> completionWidth [
	^ completionWidth ifNil: [ completionWidth := 600 ]
]

{ #category : 'settings' }
GtCompletionDummySettings >> completionWidth: aNumber [
	completionWidth := aNumber
]
