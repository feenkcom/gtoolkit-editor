Class {
	#name : 'GtTextEditorEmbedderTextCompletionRequestMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextCompletionRequestMessage class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_text_completion_request_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextCompletionRequestMessage >> documentId [
	| documentId |
	
	documentId := GtTextEditorDocumentId new.
	self primGetDocumentId: documentId.
	^ documentId
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextCompletionRequestMessage >> primGetDocumentId: documentId [
	^ self ffiBareCall: #(bool to_embedder_text_completion_request_get_document_id(self, void* documentId))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextCompletionRequestMessage >> primGetTrigger [
	^ self ffiCall: #(GtTextEditorCompletionTrigger to_embedder_text_completion_request_get_trigger(self))
]

{ #category : 'dispatching' }
GtTextEditorEmbedderTextCompletionRequestMessage >> sendTo: anObject [
	anObject onEditorTextCompletionRequest: self
]

{ #category : 'accessing' }
GtTextEditorEmbedderTextCompletionRequestMessage >> trigger [
	<return: #GtTextEditorCompletionTrigger>

	^ self primGetTrigger
]
