Class {
	#name : 'GtTextEditorEmbedderReadyToStyleMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Model',
	#package : 'GToolkit-Editor',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderReadyToStyleMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_ready_to_style_message_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderReadyToStyleMessage >> primGetText [
	^ self ffiCall: #(void* to_embedder_ready_to_style_message_get_text(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderReadyToStyleMessage >> sendTo: anObject [
	anObject onEditorReadyToStyle: self
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderReadyToStyleMessage >> text [
	^ GtTextEditorExternalText fromNativeHandle: self primGetText
]
