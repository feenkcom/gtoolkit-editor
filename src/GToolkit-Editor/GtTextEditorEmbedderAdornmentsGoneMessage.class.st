Class {
	#name : 'GtTextEditorEmbedderAdornmentsGoneMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private' }
GtTextEditorEmbedderAdornmentsGoneMessage class >> primRelease: aHandle [

	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_adornment_attributes_gone_message_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorEmbedderAdornmentsGoneMessage >> adornmentTags [
	| tags |
	tags := Array new: self primLen.
	1
		to: self primLen
		do: [ :i | tags at: i put: (self primAdornmentTagAt: i - 1) ].
	^ tags
]

{ #category : 'private' }
GtTextEditorEmbedderAdornmentsGoneMessage >> primAdornmentTagAt: anIndex [
	^ self ffiCall: #(uint64 to_embedder_adornment_attributes_gone_message_get_tag_at(self, size_t anIndex))
]

{ #category : 'private' }
GtTextEditorEmbedderAdornmentsGoneMessage >> primLen [
	^ self ffiCall: #(size_t to_embedder_adornment_attributes_gone_message_get_len(self))
]

{ #category : 'sending' }
GtTextEditorEmbedderAdornmentsGoneMessage >> sendTo: anObject [
	anObject onEditorAdornmentsGone: self
]
