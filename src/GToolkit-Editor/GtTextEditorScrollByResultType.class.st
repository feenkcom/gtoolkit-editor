Class {
	#name : 'GtTextEditorScrollByResultType',
	#superclass : 'GtExternalEnumeration',
	#classVars : [
		'DidNotScroll',
		'QueuedOrUnknown'
	],
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'accessing enum' }
GtTextEditorScrollByResultType class >> DidNotScroll [
	"This method was automatically generated"
	^ DidNotScroll
]

{ #category : 'accessing enum' }
GtTextEditorScrollByResultType class >> QueuedOrUnknown [
	"This method was automatically generated"
	^ QueuedOrUnknown
]

{ #category : 'enum declaration' }
GtTextEditorScrollByResultType class >> externalDeclaration [
	"self rebuildEnumAccessors"
	
	^ #(
		QueuedOrUnknown,
    DidNotScroll,
	)
]

{ #category : 'enum declaration' }
GtTextEditorScrollByResultType class >> externalType [
	^ FFIUInt8 new
]

{ #category : 'as yet unclassified' }
GtTextEditorScrollByResultType class >> initialize [
	super initialize
]
