Class {
	#name : 'GtTextEditorEmbedderModificationReasonInfo',
	#superclass : 'FFIExternalStructure',
	#classVars : [
		'OFFSET_END',
		'OFFSET_START',
		'OFFSET_TYPE'
	],
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

{ #category : 'field definition' }
GtTextEditorEmbedderModificationReasonInfo class >> fieldsDesc [
	"self rebuildFieldAccessors"
	^ #(
		GtTextEditorEmbedderModificationReasonType type;
		size_t start;
		size_t end;
	)
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderModificationReasonInfo >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	self class = anObject class ifFalse: [ ^ false ].

	^ self type = anObject type
		and: [ self start = anObject start and: [ self end = anObject end ] ]
]

{ #category : 'accessing - structure variables' }
GtTextEditorEmbedderModificationReasonInfo >> end [
	"This method was automatically generated"
	^handle platformSizeTAt: OFFSET_END
]

{ #category : 'accessing - structure variables' }
GtTextEditorEmbedderModificationReasonInfo >> end: anObject [
	"This method was automatically generated"
	^handle platformSizeTAt: OFFSET_END put: anObject
]

{ #category : 'comparing' }
GtTextEditorEmbedderModificationReasonInfo >> hash [
	^ ((self class hash hashMultiply bitXor: self type hash hashMultiply)
		bitXor: self start hash hashMultiply) bitXor: self end hash hashMultiply
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderModificationReasonInfo >> printOn: aStream [
	aStream
		nextPutAll: 'Modification(type: ';
		print: self type;
		nextPutAll: ', start: ';
		print: self start;
		nextPutAll: ', end: ';
		print: self end;
		nextPutAll: ')'
]

{ #category : 'accessing - structure variables' }
GtTextEditorEmbedderModificationReasonInfo >> start [
	"This method was automatically generated"
	^handle platformSizeTAt: OFFSET_START
]

{ #category : 'accessing - structure variables' }
GtTextEditorEmbedderModificationReasonInfo >> start: anObject [
	"This method was automatically generated"
	^handle platformSizeTAt: OFFSET_START put: anObject
]

{ #category : 'accessing - structure variables' }
GtTextEditorEmbedderModificationReasonInfo >> type [
	"This method was automatically generated"
	^GtTextEditorEmbedderModificationReasonType basicNew value: (handle unsignedLongAt: OFFSET_TYPE)
]

{ #category : 'accessing - structure variables' }
GtTextEditorEmbedderModificationReasonInfo >> type: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_TYPE put: anObject value
]
