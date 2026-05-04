Class {
	#name : 'GtTextEditorEmbedderTextInsertionReason',
	#superclass : 'GtTextEditorEmbedderTextModificationReason',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextInsertionReason class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void insertion_modification_reason_release(void* aHandle))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextInsertionReason >> primGetByteEnd [
	^ self ffiCall: #(size_t insertion_modification_reason_get_byte_end(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextInsertionReason >> primGetByteStart [
	^ self ffiCall: #(size_t insertion_modification_reason_get_byte_start(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextInsertionReason >> primGetCharEnd [
	^ self ffiCall: #(size_t insertion_modification_reason_get_char_end(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextInsertionReason >> primGetCharStart [
	^ self ffiCall: #(size_t insertion_modification_reason_get_char_start(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextInsertionReason >> primGetText: aStringBox [
	^ self ffiCall: #(void insertion_modification_reason_get_text(self, void* aStringBox))
]

{ #category : 'message - dispatch' }
GtTextEditorEmbedderTextInsertionReason >> sendTo: anObject with: anotherObject [
	^ anObject onEditorTextInserted: self withMessage: anotherObject
]

{ #category : 'accessing' }
GtTextEditorEmbedderTextInsertionReason >> string [
	^ self ffiLibrary getStringFrom: [ :aStringBox | self primGetText: aStringBox ]
]
