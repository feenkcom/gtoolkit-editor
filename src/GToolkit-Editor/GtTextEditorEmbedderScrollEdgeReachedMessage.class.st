Class {
	#name : 'GtTextEditorEmbedderScrollEdgeReachedMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderScrollEdgeReachedMessage class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_scroll_edge_reached_message_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderScrollEdgeReachedMessage >> sendTo: anObject [
	anObject onEditorScrollEdgeReached: self
]
