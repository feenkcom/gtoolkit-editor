Class {
	#name : 'GtTextEditorEmbedderAdornmentsRemovedMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderAdornmentsRemovedMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_adornment_attributes_removed_message_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentsRemovedMessage >> adornmentTags [
	| tags |
	tags := Array new: self primLen.
	1
		to: self primLen
		do: [ :i | tags at: i put: (self primAdornmentTagAt: i - 1) ].
	^ tags
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentsRemovedMessage >> primAdornmentTagAt: anIndex [
	^ self ffiCall: #(uint64 to_embedder_adornment_attributes_removed_message_get_tag_at(self, size_t anIndex))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentsRemovedMessage >> primLen [
	^ self ffiCall: #(size_t to_embedder_adornment_attributes_removed_message_get_len(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentsRemovedMessage >> sendTo: anObject [
	anObject onEditorAdornmentsRemoved: self
]
