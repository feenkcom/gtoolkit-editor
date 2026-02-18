Class {
	#name : 'GtTextEditorDocumentId',
	#superclass : 'FFIExternalStructure',
	#classVars : [
		'OFFSET_REVISIONID',
		'OFFSET_TEXTID'
	],
	#category : 'GToolkit-Editor-FFI-Text',
	#package : 'GToolkit-Editor',
	#tag : 'FFI-Text'
}

{ #category : 'field definition' }
GtTextEditorDocumentId class >> fieldsDesc [
	"self rebuildFieldAccessors"
	^ #(
		uint64 textId;
		uint64 revisionId;
	)
]

{ #category : 'as yet unclassified' }
GtTextEditorDocumentId >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	self class = anObject class ifFalse: [ ^ false ].

	^ self textId = anObject textId and: [ self revisionId = anObject revisionId ]
]

{ #category : 'comparing' }
GtTextEditorDocumentId >> hash [
	^ (self class hash hashMultiply bitXor: self textId hash hashMultiply)
		bitXor: self revisionId hash hashMultiply
]

{ #category : 'as yet unclassified' }
GtTextEditorDocumentId >> printOn: aStream [
	aStream
		nextPutAll: 'DocumentId(id: ';
		print: self textId;
		nextPutAll: ', revision: ';
		print: self revisionId;
		nextPutAll: ')'
]

{ #category : 'accessing - structure variables' }
GtTextEditorDocumentId >> revisionId [
	"This method was automatically generated"
	^handle unsignedLongLongAt: OFFSET_REVISIONID
]

{ #category : 'accessing - structure variables' }
GtTextEditorDocumentId >> revisionId: anObject [
	"This method was automatically generated"
	handle unsignedLongLongAt: OFFSET_REVISIONID put: anObject
]

{ #category : 'accessing - structure variables' }
GtTextEditorDocumentId >> textId [
	"This method was automatically generated"
	^handle unsignedLongLongAt: OFFSET_TEXTID
]

{ #category : 'accessing - structure variables' }
GtTextEditorDocumentId >> textId: anObject [
	"This method was automatically generated"
	handle unsignedLongLongAt: OFFSET_TEXTID put: anObject
]
