Class {
	#name : 'GtTextEditorHandle',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Model',
	#package : 'GToolkit-Editor',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
GtTextEditorHandle class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle class >> forEmbedder: aTextEditorEmbedder [
	^ self fromNativeHandle: (self primNew: aTextEditorEmbedder)
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle class >> primNew: pharoEditorEmbedder [
	^ self ffiCall: #(void* editor_handle_new(void* pharoEditorEmbedder))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void editor_handle_release(void* aHandle))
]

{ #category : 'adding' }
GtTextEditorHandle >> addAttribute: anAttribute from: aStart to: anEnd [
	anAttribute asGtExternalTextAttributeDuring: [ :aTextAttribute |
		self
			primAddAttribute: aTextAttribute
			start: aStart - 1
			end: anEnd - 1 ].
]

{ #category : 'adding' }
GtTextEditorHandle >> addAttribute: anAttribute overAdornment: anAdornmentId [
	<return: #GtTextEditorAttributeTag>
	^ anAttribute asGtExternalTextAttributeDuring: [ :aTextAttribute |
		| anAttributeTag |
		
		anAttributeTag := GtTextEditorAttributeTag new.
		
		self
			primAddAttribute: aTextAttribute
			overAdornment: anAdornmentId
			tag: anAttributeTag.
		
		anAttributeTag ]
]

{ #category : 'adding' }
GtTextEditorHandle >> addCursorAtVisualPoint: aPoint [
	self
		primAddCursorAtVisualX: aPoint x
		y: aPoint y
]

{ #category : 'accessing' }
GtTextEditorHandle >> defaultFontName: aFontFamilyName [
	self ffiLibrary
		newString: aFontFamilyName
		during: [ :aStringBox | self primSetDefaultFontFamily: aStringBox ]
]

{ #category : 'accessing' }
GtTextEditorHandle >> defaultFontSize: aNumber [
	self primSetDefaultFontSize: aNumber
]

{ #category : 'accessing' }
GtTextEditorHandle >> defaultForeground: aColor [
	self
		primSetDefaultForegroundRed: aColor red
		green: aColor green
		blue: aColor blue
		alpha: aColor alpha
]

{ #category : 'api - editing' }
GtTextEditorHandle >> deleteNextAtCursor [
	self primDeleteNextAtCursor
]

{ #category : 'api - editing' }
GtTextEditorHandle >> deletePreviousAtCursor [
	self primDeletePreviousAtCursor
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> editorClone [
	^ GtTextEditorModel fromNativeHandle: self primQueryEditorClone
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> endSelectionAtVisualPoint [
	self primEndSelectionAtVisualPoint
]

{ #category : 'accessing' }
GtTextEditorHandle >> height [
	^ self primGetHeight
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> insertStringAtCursor: aString [
	self ffiLibrary
		newString: aString
		during: [ :aStringBox | self primInsertString: aStringBox ]
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> measureWidth: aWidth top: aTopOrNil height: aHeightOrNil [
	self
		primMeasureWidth: aWidth
		hasViewportTop: aTopOrNil isNotNil
		viewportTop: (aTopOrNil ifNil: [ 0.0])
		hasViewportHeight:  aHeightOrNil isNotNil
		viewportHeight: (aHeightOrNil ifNil: [ 0.0])
]

{ #category : 'accessing' }
GtTextEditorHandle >> metrics [
	^ GtTextEditorMetrics fromNativeHandle: self primQueryMetrics
]

{ #category : 'api - navigation' }
GtTextEditorHandle >> moveCursorLeft [
	^ self primMoveCursorLeft
]

{ #category : 'api - navigation' }
GtTextEditorHandle >> moveCursorRight [
	^ self primMoveCursorRight
]

{ #category : 'api - navigation' }
GtTextEditorHandle >> moveCursorToBeginning [
	^ self primMoveCursorToBeginning
]

{ #category : 'api - navigation' }
GtTextEditorHandle >> moveCursorToEnd [
	^ self primMoveCursorToEnd
]

{ #category : 'api - navigation' }
GtTextEditorHandle >> moveCursorToLineEnd [
	^ self primMoveCursorToLineEnd
]

{ #category : 'api - navigation' }
GtTextEditorHandle >> moveCursorToLineStart [
	^ self primMoveCursorToLineStart
]

{ #category : 'api - navigation' }
GtTextEditorHandle >> moveCursorToVisualPoint: aPoint [
	self
		primMoveCursorToVisualX: aPoint x
		y: aPoint y
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primAddAttribute: anAttribute overAdornment: anAdornmentId tag: aTagPointer [
	self ffiBareCall: #(void editor_handle_add_text_attribute_over_adornment(
		self,
		void* anAttribute,
		uint64 anAdornmentId,
		void* aTagPointer))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primAddAttribute: anAttribute start: aStart end: anEnd [
	self ffiCall: #(void editor_handle_add_text_attribute(
		self,
		void* anAttribute,
		size_t aStart,
		size_t anEnd))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primAddCursorAtVisualX: aX y: aY [
	self ffiCall: #(void editor_handle_add_cursor_at_visual_point(
		self,
		float64 aX,
		float64 aY))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primCreateAdornmentDynamicOffset: anAdornmentId [
	^ self ffiCall: #(void* editor_handle_make_dynamic_offset_payload(self, uint64 anAdornmentId))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primDeleteNextAtCursor [
	self ffiCall: #(void editor_handle_delete_next_at_carets(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primDeletePreviousAtCursor [
	self ffiCall: #(void editor_handle_delete_previous_at_carets(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primEndSelectionAtVisualPoint [
	self ffiCall: #(void editor_handle_end_selection_at_visual_point(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primGetHeight [
	self ffiCall: #(float64 editor_handle_get_height(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primGetUnstyledText [
	self ffiCall: #(void* editor_handle_get_unstyled_text(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> primInsertString: aStringBox [
	^ self ffiCall: #(void editor_handle_insert_str(
		self,
		void* aStringBox))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> primMeasureWidth: aWidth hasViewportTop: hasViewportTop viewportTop: viewportTop hasViewportHeight:  hasViewportHeight viewportHeight: viewportHeight [
	self ffiCall: #(void editor_handle_resize(
		self,
		float64 aWidth,
		bool hasViewportTop,
		float64 viewportTop,
		bool hasViewportHeight,
		float64 viewportHeight))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primMoveCursorLeft [
	self ffiCall: #(void editor_handle_move_cursor_left(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primMoveCursorRight [
	self ffiCall: #(void editor_handle_move_cursor_right(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primMoveCursorToBeginning [
	self ffiCall: #(void editor_handle_move_cursor_to_beginning(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primMoveCursorToEnd [
	self ffiCall: #(void editor_handle_move_cursor_to_end(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primMoveCursorToLineEnd [
	self ffiCall: #(void editor_handle_move_cursor_to_line_end(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primMoveCursorToLineStart [
	self ffiCall: #(void editor_handle_move_cursor_to_line_start(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primMoveCursorToVisualX: aX y: aY [
	self ffiCall: #(void editor_handle_move_cursor_to_visual_point(
		self,
		float64 aX,
		float64 aY))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> primQueryEditorClone [
	^ self ffiCall: #(void* editor_handle_query_editor(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> primQueryMetrics [
	^ self ffiCall: #(void* editor_handle_query_metrics(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> primResizeAdornment: anId width: aWidth height: aHeight [
	^ self ffiCall: #(void editor_handle_resize_adornment(
		self,
		uint64 anId,
		float64 aWidth,
		float64 aHeight))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> primScrollBy: aY [
	self ffiCall: #(void editor_handle_scroll_by(self, float64 aY))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primSetDefaultFontFamily: aStringBox [
	self ffiCall: #(void editor_handle_set_default_font_family(self, void* aStringBox))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primSetDefaultFontSize: aNumber [
	self ffiCall: #(void editor_handle_set_default_font_size(self, float32 aNumber))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primSetDefaultForegroundRed: red green: green blue: blue alpha: alpha [
	self ffiCall: #(void editor_handle_set_default_text_foreground(
		self,
		float32 red,
		float32 green,
		float32 blue,
		float32 alpha))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> primSetRenderThreadWakerThunk: thunk [
	^ self ffiCall: #(void editor_handle_set_render_thread_thunk(self, void* thunk))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> primSetStyledText: aGtTextEditorExternalText [
	self ffiCall: #(void editor_handle_set_styled_text(self, void* aGtTextEditorExternalText))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> primSetText: aGtTextEditorExternalText [
	self ffiCall: #(void editor_handle_set_text(self, void* aGtTextEditorExternalText))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primStartSelectionAtVisualX: aX y: aY [
	self ffiCall: #(void editor_handle_start_selection_at_visual_point(
		self,
		float64 aX,
		float64 aY))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primUpdateSelectionAtVisualX: aX y: aY [
	self ffiCall: #(void editor_handle_update_selection_at_visual_point(
		self,
		float64 aX,
		float64 aY))
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> resizeAdornment: anId extent: aPoint [
	self
		primResizeAdornment: anId
		width: aPoint x
		height: aPoint y
]

{ #category : 'api - scrolling' }
GtTextEditorHandle >> scrollBy: aY [
	self primScrollBy: aY
]

{ #category : 'initialization' }
GtTextEditorHandle >> setRenderThreadWakerThunk: aWindow [
	self primSetRenderThreadWakerThunk: aWindow
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> startSelectionAtVisualPoint: aPoint [
	self primStartSelectionAtVisualX: aPoint x y: aPoint y
]

{ #category : 'accessing' }
GtTextEditorHandle >> styledText: aGtTextEditorExternalText [
	self primSetStyledText: aGtTextEditorExternalText
]

{ #category : 'accessing' }
GtTextEditorHandle >> text: aGtTextEditorExternalText [
	self primSetText: aGtTextEditorExternalText
]

{ #category : 'accessing' }
GtTextEditorHandle >> unstyledText [
	^ GtTextEditorExternalText fromNativeHandle: self primGetUnstyledText
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> updateSelectionAtVisualPoint: aPoint [
	self primUpdateSelectionAtVisualX: aPoint x y: aPoint y
]
