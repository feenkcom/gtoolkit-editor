Class {
	#name : 'GtTextEditorStylingTrigger',
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
GtTextEditorStylingTrigger class >> Auto [
	"This method was automatically generated"
	^ Auto
]

{ #category : 'accessing enum' }
GtTextEditorStylingTrigger class >> Manual [
	"This method was automatically generated"
	^ Manual
]

{ #category : 'enum declaration' }
GtTextEditorStylingTrigger class >> externalDeclaration [
	"self rebuildEnumAccessors"
	
	^ #(
		Manual,
		Auto
	)
]

{ #category : 'enum declaration' }
GtTextEditorStylingTrigger class >> externalType [
	^ FFIUInt8 new
]

{ #category : 'as yet unclassified' }
GtTextEditorStylingTrigger class >> initialize [
	super initialize
]
