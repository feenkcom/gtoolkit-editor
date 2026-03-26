Class {
	#name : 'GtTextEditorEmbedderActiveCaretMovedMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderActiveCaretMovedMessage class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_active_caret_moved_message_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderActiveCaretMovedMessage >> newOffset [
	^ self primGetToRawOffset
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderActiveCaretMovedMessage >> primGetToRawOffset [
	^ self ffiCall: #(size_t to_embedder_active_caret_moved_message_to_raw_offset(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderActiveCaretMovedMessage >> sendTo: anObject [
	anObject onEditorActiveCaretMoved: self
]
