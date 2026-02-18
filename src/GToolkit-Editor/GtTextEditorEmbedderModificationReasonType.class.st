Class {
	#name : 'GtTextEditorEmbedderModificationReasonType',
	#superclass : 'GtExternalEnumeration',
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

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
