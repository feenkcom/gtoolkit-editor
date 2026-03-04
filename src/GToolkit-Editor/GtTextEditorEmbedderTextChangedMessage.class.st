Class {
	#name : 'GtTextEditorEmbedderTextChangedMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextChangedMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_text_changed_message_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextChangedMessage >> primGetModificationReason: aModificationInfo at: anIndex [
	^ self ffiBareCall: #(bool to_embedder_text_changed_message_get_modification_reason_at(
		self,
		size_t anIndex,
		void* aModificationInfo))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextChangedMessage >> primGetModificationReasonsSize [
	^ self ffiCall: #(size_t to_embedder_text_changed_message_get_modification_reasons_len(self))
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
