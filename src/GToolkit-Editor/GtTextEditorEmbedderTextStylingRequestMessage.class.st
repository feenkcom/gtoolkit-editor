Class {
	#name : 'GtTextEditorEmbedderTextStylingRequestMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextStylingRequestMessage class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_text_styling_request_release(void* aHandle))
]

{ #category : 'dispatching' }
GtTextEditorEmbedderTextStylingRequestMessage >> sendTo: anObject [
	anObject onEditorTextStylingRequest: self
]
