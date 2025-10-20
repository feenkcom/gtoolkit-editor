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

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> addAttribute: anAttribute from: aStart to: anEnd [
	self
		primAddAttribute: anAttribute
		start: aStart - 1
		end: anEnd - 1
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> addCursorAtVisualPoint: aPoint [
	self
		primAddCursorAtVisualX: aPoint x
		y: aPoint y
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> endSelectionAtVisualPoint [
	self primEndSelectionAtVisualPoint
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

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> moveCursorToBeginning [
	^ self primMoveCursorToBeginning
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> moveCursorToEnd [
	^ self primMoveCursorToEnd
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> moveCursorToLineEnd [
	^ self primMoveCursorToLineEnd
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> moveCursorToLineStart [
	^ self primMoveCursorToLineStart
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> moveCursorToVisualPoint: aPoint [
	self
		primMoveCursorToVisualX: aPoint x
		y: aPoint y
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primAddAttribute: anAttribute start: aStart end: anEnd [
	self ffiCall: #(void editor_handle_add_text_attribute(
		self,
		void* anAttribute,
		size_t aStart,
		size_t anEnd))
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primAddCursorAtVisualX: aX y: aY [
	self ffiCall: #(void editor_handle_add_cursor_at_visual_point(
		self,
		float64 aX,
		float64 aY))
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primEndSelectionAtVisualPoint [
	self ffiCall: #(void editor_handle_end_selection_at_visual_point(self))
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

{ #category : #'private - ffi' }
GtTextEditorHandle >> primMoveCursorToBeginning [
	self ffiCall: #(void editor_handle_move_cursor_to_beginning(self))
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primMoveCursorToEnd [
	self ffiCall: #(void editor_handle_move_cursor_to_end(self))
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primMoveCursorToLineEnd [
	self ffiCall: #(void editor_handle_move_cursor_to_line_end(self))
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primMoveCursorToLineStart [
	self ffiCall: #(void editor_handle_move_cursor_to_line_start(self))
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primMoveCursorToVisualX: aX y: aY [
	self ffiCall: #(void editor_handle_move_cursor_to_visual_point(
		self,
		float64 aX,
		float64 aY))
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

{ #category : #'private - ffi' }
GtTextEditorHandle >> primStartSelectionAtVisualX: aX y: aY [
	self ffiCall: #(void editor_handle_start_selection_at_visual_point(
		self,
		float64 aX,
		float64 aY))
]

{ #category : #'private - ffi' }
GtTextEditorHandle >> primUpdateSelectionAtVisualX: aX y: aY [
	self ffiCall: #(void editor_handle_update_selection_at_visual_point(
		self,
		float64 aX,
		float64 aY))
]

{ #category : #'api - scrolling' }
GtTextEditorHandle >> scrollBy: aY [
	self primScrollBy: aY
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> setRenderThreadWakerThunk: aWindow [
	self primSetRenderThreadWakerThunk: aWindow
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> startSelectionAtVisualPoint: aPoint [
	self primStartSelectionAtVisualX: aPoint x y: aPoint y
]

{ #category : #'as yet unclassified' }
GtTextEditorHandle >> updateSelectionAtVisualPoint: aPoint [
	self primUpdateSelectionAtVisualX: aPoint x y: aPoint y
]
