Class {
	#name : 'GtTextEditorScrollEdgeType',
	#superclass : 'GtExternalEnumeration',
	#classVars : [
		'Bottom',
		'Top'
	],
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'accessing enum' }
GtTextEditorScrollEdgeType class >> Bottom [
	"This method was automatically generated"
	^ Bottom
]

{ #category : 'accessing enum' }
GtTextEditorScrollEdgeType class >> Top [
	"This method was automatically generated"
	^ Top
]

{ #category : 'enum declaration' }
GtTextEditorScrollEdgeType class >> externalDeclaration [
	"self rebuildEnumAccessors"
	
	^ #(
		Top,
		Bottom
	)
]

{ #category : 'enum declaration' }
GtTextEditorScrollEdgeType class >> externalType [
	^ FFIUInt8 new
]

{ #category : 'as yet unclassified' }
GtTextEditorScrollEdgeType class >> initialize [
	super initialize
]
