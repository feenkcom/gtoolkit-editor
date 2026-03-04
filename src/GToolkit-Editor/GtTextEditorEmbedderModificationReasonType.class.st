Class {
	#name : 'GtTextEditorEmbedderModificationReasonType',
	#superclass : 'GtExternalEnumeration',
	#classVars : [
		'Deletion',
		'Insertion',
		'Unknown'
	],
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

{ #category : 'accessing enum' }
GtTextEditorEmbedderModificationReasonType class >> Deletion [
	"This method was automatically generated"
	^ Deletion
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderModificationReasonType class >> Insertion [
	"This method was automatically generated"
	^ Insertion
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderModificationReasonType class >> Unknown [
	"This method was automatically generated"
	^ Unknown
]

{ #category : 'ffi' }
GtTextEditorEmbedderModificationReasonType class >> externalDeclaration [
	^ #(
		Unknown,
		Insertion,
		Deletion,
	)
]

{ #category : 'ffi' }
GtTextEditorEmbedderModificationReasonType class >> externalType [
	^ FFIUInt8 new
]
