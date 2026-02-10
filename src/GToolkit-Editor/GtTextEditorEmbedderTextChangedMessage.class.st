Class {
	#name : 'GtTextEditorEmbedderTextChangedMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Model',
	#package : 'GToolkit-Editor',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextChangedMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_text_changed_message_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextChangedMessage >> primGetText [
	^ self ffiCall: #(void* to_embedder_text_changed_message_get_text(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextChangedMessage >> sendTo: anObject [
	anObject onEditorTextChanged: self
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextChangedMessage >> text [
	^ GtTextEditorExternalText fromNativeHandle: self primGetText
]
