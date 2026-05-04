Class {
	#name : 'GtTextEditorEmbedderTextDeletionReason',
	#superclass : 'GtTextEditorEmbedderTextModificationReason',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextDeletionReason class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void deletion_modification_reason_release(void* aHandle))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextDeletionReason >> primGetByteEnd [
	^ self ffiCall: #(size_t deletion_modification_reason_get_byte_end(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextDeletionReason >> primGetByteStart [
	^ self ffiCall: #(size_t deletion_modification_reason_get_byte_start(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextDeletionReason >> primGetCharEnd [
	^ self ffiCall: #(size_t deletion_modification_reason_get_char_end(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextDeletionReason >> primGetCharStart [
	^ self ffiCall: #(size_t deletion_modification_reason_get_char_start(self))
]

{ #category : 'message - dispatch' }
GtTextEditorEmbedderTextDeletionReason >> sendTo: anObject with: anotherObject [
	^ anObject onEditorTextDeleted: self withMessage: anotherObject
]
