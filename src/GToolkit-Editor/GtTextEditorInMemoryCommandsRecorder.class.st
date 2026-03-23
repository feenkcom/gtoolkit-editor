Class {
	#name : 'GtTextEditorInMemoryCommandsRecorder',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'library path' }
GtTextEditorInMemoryCommandsRecorder class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'private - ffi' }
GtTextEditorInMemoryCommandsRecorder class >> primCreate [
	^ self ffiCall: #(void* in_memory_commands_recorder_new())
]

{ #category : 'private - ffi' }
GtTextEditorInMemoryCommandsRecorder class >> primRelease: aHandle [
	self ffiCall: #(void in_memory_commands_recorder_release(void* aHandle))
]

{ #category : 'private - ffi' }
GtTextEditorInMemoryCommandsRecorder >> primGetPhlowVTable [
	^ self ffiCall: #(void* in_memory_commands_recorder_phlow_vtable(self))
]
