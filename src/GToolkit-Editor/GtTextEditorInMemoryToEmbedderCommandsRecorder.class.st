Class {
	#name : 'GtTextEditorInMemoryToEmbedderCommandsRecorder',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'library path' }
GtTextEditorInMemoryToEmbedderCommandsRecorder class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'private - ffi' }
GtTextEditorInMemoryToEmbedderCommandsRecorder class >> primCreate [
	^ self ffiCall: #(void* in_memory_to_embedder_messages_recorder_new())
]

{ #category : 'private - ffi' }
GtTextEditorInMemoryToEmbedderCommandsRecorder class >> primRelease: aHandle [
	self ffiCall: #(void in_memory_to_embedder_messages_recorder_release(void* aHandle))
]

{ #category : 'private - ffi' }
GtTextEditorInMemoryToEmbedderCommandsRecorder >> primGetPhlowVTable [
	^ self ffiCall: #(void* in_memory_to_embedder_messages_recorder_phlow_vtable(self))
]
