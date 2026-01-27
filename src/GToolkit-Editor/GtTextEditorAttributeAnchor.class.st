Class {
	#name : 'GtTextEditorAttributeAnchor',
	#superclass : 'FFIExternalStructure',
	#classVars : [
		'OFFSET_BIAS',
		'OFFSET_OFFSET'
	],
	#category : 'GToolkit-Editor-FFI-Text',
	#package : 'GToolkit-Editor',
	#tag : 'FFI-Text'
}

{ #category : 'field definition' }
GtTextEditorAttributeAnchor class >> fieldsDesc [
	"self rebuildFieldAccessors"
	^ #(
	size_t offset;
	uint8 bias;
	)
]

{ #category : 'instance creation' }
GtTextEditorAttributeAnchor class >> left: anOffset [
	^ self new
		offset: anOffset;
		bias: 0
]

{ #category : 'instance creation' }
GtTextEditorAttributeAnchor class >> right: anOffset [
	^ self new
		offset: anOffset;
		bias: 1
]

{ #category : 'accessing - structure variables' }
GtTextEditorAttributeAnchor >> bias [
	"This method was automatically generated"
	^handle unsignedByteAt: OFFSET_BIAS
]

{ #category : 'accessing - structure variables' }
GtTextEditorAttributeAnchor >> bias: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: OFFSET_BIAS put: anObject
]

{ #category : 'accessing - structure variables' }
GtTextEditorAttributeAnchor >> offset [
	"This method was automatically generated"
	^handle platformSizeTAt: OFFSET_OFFSET
]

{ #category : 'accessing - structure variables' }
GtTextEditorAttributeAnchor >> offset: anObject [
	"This method was automatically generated"
	^handle platformSizeTAt: OFFSET_OFFSET put: anObject
]
