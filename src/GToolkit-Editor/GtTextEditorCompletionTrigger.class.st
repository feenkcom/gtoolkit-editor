Class {
	#name : 'GtTextEditorCompletionTrigger',
	#superclass : 'GtExternalEnumeration',
	#classVars : [
		'Auto',
		'Manual'
	],
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'accessing enum' }
GtTextEditorCompletionTrigger class >> Auto [
	"This method was automatically generated"
	^ Auto
]

{ #category : 'accessing enum' }
GtTextEditorCompletionTrigger class >> Manual [
	"This method was automatically generated"
	^ Manual
]

{ #category : 'enum declaration' }
GtTextEditorCompletionTrigger class >> externalDeclaration [
	"self rebuildEnumAccessors"
	
	^ #(
		Manual,
		Auto
	)
]

{ #category : 'enum declaration' }
GtTextEditorCompletionTrigger class >> externalType [
	^ FFIUInt8 new
]

{ #category : 'as yet unclassified' }
GtTextEditorCompletionTrigger >> isManual [
	^ self = Manual
]
