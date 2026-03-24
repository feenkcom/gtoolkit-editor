Class {
	#name : 'GtTextEditorEmbedder',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedder class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedder class >> forSemaphoreIndex: semaphoreIndex during: aBlock [
	| renderThreadCallout renderThread semaphoreSignaller redrawRequestor |
	
	renderThreadCallout := FFIBackend current
		loadSymbol: #winit_application_call_function
		module: Winit30Library uniqueInstance libraryName.
	renderThread := RustWindowingEventFetcher default eventLoop.

	redrawRequestor := FFIBackend current
		loadSymbol: #winit_window_handle_request_redraw
		module: Winit30Library uniqueInstance libraryName.

	semaphoreSignaller := self primitiveGetSemaphoreSignaller.
	semaphoreSignaller isNull ifTrue: [ self error: 'Primitive is missing' ].

	^ self
		fromNativeHandle: (self
				primNewRenderThread: renderThread
				callout: renderThreadCallout
				redrawRequestor: redrawRequestor
				semaphoreSignaller: semaphoreSignaller
				index: semaphoreIndex)
		during: aBlock
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedder class >> primNewRenderThread: renderThread callout: renderThreadCallout redrawRequestor: redrawRequestor  semaphoreSignaller: semaphoreSignaller index: semaphoreIndex [
	^ self ffiCall: #(void* editor_embedder_new(
		void* renderThread,
		void* renderThreadCallout,
		void* redrawRequestor,
		void* semaphoreSignaller,
		size_t semaphoreIndex))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedder class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void editor_embedder_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedder class >> primitiveGetSemaphoreSignaller [
	<primitive: 'primitiveGetSemaphoreSignaller'>

	^ ExternalAddress null
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedder >> messagesQueue [
	^ GtTextEditorEmbedderMessageQueue fromNativeHandle: self primGetMessagesQueue
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedder >> primGetMessagesQueue [
	^ self ffiCall: #(void* editor_embedder_get_messages(self))
]
