Class {
	#name : 'GtTextEditorEmbedderAdornmentsAddedMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderAdornmentsAddedMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_adornment_attributes_added_message_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentsAddedMessage >> adornmentTags [
	| tags |
	tags := Array new: self primLen.
	1
		to: self primLen
		do: [ :i | tags at: i put: (self primAdornmentTagAt: i - 1) ].
	^ tags
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentsAddedMessage >> primAdornmentTagAt: anIndex [
	^ self ffiCall: #(uint64 to_embedder_adornment_attributes_added_message_get_tag_at(self, size_t anIndex))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentsAddedMessage >> primLen [
	^ self ffiCall: #(size_t to_embedder_adornment_attributes_added_message_get_len(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentsAddedMessage >> sendTo: anObject [
	anObject onEditorAdornmentsAdded: self
]
