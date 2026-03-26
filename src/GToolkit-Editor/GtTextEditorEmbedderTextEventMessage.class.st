Class {
	#name : 'GtTextEditorEmbedderTextEventMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextEventMessage class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_text_event_message_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextEventMessage >> sendTo: anObject [
]
