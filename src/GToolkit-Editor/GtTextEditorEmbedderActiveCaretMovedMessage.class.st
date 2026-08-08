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

{ #category : 'instance creation' }
GtTextEditorEmbedderActiveCaretMovedMessage >> newCharacterOffset [
	^ self primGetToCharacterOffset
]

{ #category : 'instance creation' }
GtTextEditorEmbedderActiveCaretMovedMessage >> newOffset [
	^ self primGetToRawOffset
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderActiveCaretMovedMessage >> primGetToCharacterOffset [
	^ self ffiCall: #(size_t to_embedder_active_caret_moved_message_to_character_offset(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderActiveCaretMovedMessage >> primGetToRawOffset [
	^ self ffiCall: #(size_t to_embedder_active_caret_moved_message_to_raw_offset(self))
]

{ #category : 'message - dispatch' }
GtTextEditorEmbedderActiveCaretMovedMessage >> sendTo: anObject [
	anObject onEditorActiveCaretMoved: self
]
