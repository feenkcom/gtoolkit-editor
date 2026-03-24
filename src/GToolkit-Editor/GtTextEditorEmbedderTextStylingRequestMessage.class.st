Class {
	#name : 'GtTextEditorEmbedderTextStylingRequestMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextStylingRequestMessage class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_text_styling_request_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorEmbedderTextStylingRequestMessage >> documentId [
	| documentId |
	
	documentId := GtTextEditorDocumentId new.
	self primGetDocumentId: documentId.
	^ documentId
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextStylingRequestMessage >> primGetDocumentId: documentId [
	^ self ffiBareCall: #(bool to_embedder_text_styling_request_get_document_id(self, void* documentId))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextStylingRequestMessage >> primGetUnstyledText [
	^ self ffiCall: #(void* to_embedder_text_styling_request_get_text(self))
]

{ #category : 'dispatching' }
GtTextEditorEmbedderTextStylingRequestMessage >> sendTo: anObject [
	anObject onEditorTextStylingRequest: self
]

{ #category : 'accessing' }
GtTextEditorEmbedderTextStylingRequestMessage >> unstyledText [
	^ GtTextEditorExternalText fromNativeHandle: self primGetUnstyledText
]
