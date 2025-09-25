Class {
	#name : #GtTextEditorHandle,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorHandle class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle class >> forSemaphoreIndex: semaphoreIndex [
	^ self
		fromNativeHandle: (GtTextEditorEmbedder
				forSemaphoreIndex: semaphoreIndex
				during: [ :pharoEmbedder | self primNew: pharoEmbedder ])
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle class >> primNew: pharoEditorEmbedder [
	^ self ffiCall: #(void* editor_handle_new(void* pharoEditorEmbedder))
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void editor_handle_release(void* aHandle))
]

{ #category : #accessing }
GtTextEditorHandle >> height [
	^ self primGetHeight
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> insertStringAtCursor: aString [
	self ffiLibrary
		newString: aString
		during: [ :aStringBox | self primInsertString: aStringBox ]
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> measureWidth: aWidth top: aTopOrNil height: aHeightOrNil [
	self
		primMeasureWidth: aWidth
		hasViewportTop: aTopOrNil isNotNil
		viewportTop: (aTopOrNil ifNil: [ 0.0])
		hasViewportHeight:  aHeightOrNil isNotNil
		viewportHeight: (aHeightOrNil ifNil: [ 0.0])
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> metrics [
	^ GtTextEditorMetrics fromNativeHandle: self primQueryMetrics
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> moveCursorLeft [
	^ self primMoveCursorLeft
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> moveCursorRight [
	^ self primMoveCursorRight
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primGetHeight [
	self ffiCall: #(float64 editor_handle_get_height(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> primInsertString: aStringBox [
	^ self ffiCall: #(void editor_handle_insert_str(
		self,
		void* aStringBox))
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> primMeasureWidth: aWidth hasViewportTop: hasViewportTop viewportTop: viewportTop hasViewportHeight:  hasViewportHeight viewportHeight: viewportHeight [
	self ffiCall: #(void editor_handle_resize(
		self,
		float64 aWidth,
		bool hasViewportTop,
		float64 viewportTop,
		bool hasViewportHeight,
		float64 viewportHeight))
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primMoveCursorLeft [
	self ffiCall: #(void editor_handle_move_cursor_left(self))
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primMoveCursorRight [
	self ffiCall: #(void editor_handle_move_cursor_right(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> primQueryMetrics [
	^ self ffiCall: #(void* editor_handle_query_metrics(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> primScrollBy: aY [
	self ffiCall: #(void editor_handle_scroll_by(self, float64 aY))
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> primSetRenderThreadWakerThunk: thunk [
	^ self ffiCall: #(void editor_handle_set_render_thread_thunk(self, void* thunk))
]

{ #category : #'api - scrolling' }
GtTextEditorHandle >> scrollBy: aY [
	self primScrollBy: aY
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> setRenderThreadWakerThunk: aWindow [
	self primSetRenderThreadWakerThunk: aWindow
]
