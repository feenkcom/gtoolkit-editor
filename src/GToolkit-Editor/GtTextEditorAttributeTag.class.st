Class {
	#name : 'GtTextEditorAttributeTag',
	#superclass : 'FFIExternalStructure',
	#classVars : [
		'OFFSET_ID',
		'OFFSET_KIND'
	],
	#category : 'GToolkit-Editor-FFI-Text',
	#package : 'GToolkit-Editor',
	#tag : 'FFI-Text'
}

{ #category : 'field definition' }
GtTextEditorAttributeTag class >> fieldsDesc [
	"self rebuildFieldAccessors"
	^ #(
	uint8 kind;
	uint64 id;
	)
]

{ #category : 'comparing' }
GtTextEditorAttributeTag >> = anObject [
	self == anObject
		ifTrue: [ ^ true ].
	
	self class = anObject class
		ifFalse: [ ^ false ].
		
	^ self kind = anObject kind
		and: [ self id = anObject id ]
]

{ #category : 'comparing' }
GtTextEditorAttributeTag >> hash [
	^ self id hash bitXor: self kind hash
]

{ #category : 'accessing - structure variables' }
GtTextEditorAttributeTag >> id [
	"This method was automatically generated"
	^handle unsignedLongLongAt: OFFSET_ID
]

{ #category : 'accessing - structure variables' }
GtTextEditorAttributeTag >> id: anObject [
	"This method was automatically generated"
	handle unsignedLongLongAt: OFFSET_ID put: anObject
]

{ #category : 'accessing - structure variables' }
GtTextEditorAttributeTag >> kind [
	"This method was automatically generated"
	^handle unsignedByteAt: OFFSET_KIND
]

{ #category : 'accessing - structure variables' }
GtTextEditorAttributeTag >> kind: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: OFFSET_KIND put: anObject
]
