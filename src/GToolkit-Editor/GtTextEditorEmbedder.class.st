Class {
	#name : #GtTextEditorEmbedder,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorEmbedder class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorEmbedder class >> forSemaphoreIndex: semaphoreIndex during: aBlock [
	| renderThreadCallout renderThread semaphoreSignaller redrawRequestor measurer|
	
	renderThreadCallout := FFIBackend current
		loadSymbol: #winit_application_call_function
		module: Winit30Library uniqueInstance libraryName.
	renderThread := RustWindowingEventFetcher default eventLoop.

	redrawRequestor := FFIBackend current
		loadSymbol: #winit_window_handle_request_redraw
		module: Winit30Library uniqueInstance libraryName.

	semaphoreSignaller := self primitiveGetSemaphoreSignaller.
	semaphoreSignaller isNull ifTrue: [ self error: 'Primitive is missing' ].
	
	measurer := FFICallback
		signature:  #(void (size_t id, float64 width))
		block: [ :id :width |
			NonInteractiveTranscript stdout
				nextPutAll: 'measure adornment: ';
				nextPutAll: id asString;
				nextPutAll: ' width: ';
				nextPutAll: width asString;
				cr.
		].
		
	NonInteractiveTranscript stdout
		nextPutAll: measurer getHandle printString;
		cr.

	^ self
		fromNativeHandle: (self
				primNewRenderThread: renderThread
				callout: renderThreadCallout
				redrawRequestor: redrawRequestor
				semaphoreSignaller: semaphoreSignaller
				index: semaphoreIndex
				thunk: ExternalAddress null
				adornmentsMeasurer: measurer getHandle)
		during: aBlock
]

{ #category : #'as yet unclassified' }
GtTextEditorEmbedder class >> primNewRenderThread: renderThread callout: renderThreadCallout redrawRequestor: redrawRequestor  semaphoreSignaller: semaphoreSignaller index: semaphoreIndex thunk: semaphoreThunk adornmentsMeasurer: aCallback [
	^ self ffiCall: #(void* editor_embedder_new(
		void* renderThread,
		void* renderThreadCallout,
		void* redrawRequestor,
		void* semaphoreSignaller,
		size_t semaphoreIndex,
		void* semaphoreThunk,
		void* aCallback))
]

{ #category : #'as yet unclassified' }
GtTextEditorEmbedder class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void editor_embedder_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorEmbedder class >> primitiveGetSemaphoreSignaller [
	<primitive: 'primitiveGetSemaphoreSignaller'>

	^ ExternalAddress null
]
