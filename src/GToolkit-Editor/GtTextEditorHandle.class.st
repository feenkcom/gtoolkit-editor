Class {
	#name : 'GtTextEditorHandle',
	#superclass : 'GtBoxerValueBox',
	#instVars : [
		'commandsRecorder'
	],
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'library path' }
GtTextEditorHandle class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle class >> forEmbedder: aTextEditorEmbedder [
	^ self fromNativeHandle: (self primNew: aTextEditorEmbedder transferOwnership)
]

{ #category : 'private - ffi' }
GtTextEditorHandle class >> primNew: pharoEditorEmbedder [
	^ self ffiCall: #(void* editor_handle_new(void* pharoEditorEmbedder))
]

{ #category : 'private - ffi' }
GtTextEditorHandle class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void editor_handle_release(void* aHandle))
]

{ #category : 'api - attributes' }
GtTextEditorHandle >> addAttribute: anAttribute from: aStart to: anEnd [
	<return: #Number>

	^ anAttribute asGtExternalTextAttributeDuring: [ :aTextAttribute |
		self
			primAddAttribute: aTextAttribute
			start: aStart - 1
			end: anEnd - 1 ].
]

{ #category : 'api - attributes' }
GtTextEditorHandle >> addAttribute: anAttribute from: aStart to: anEnd documentId: documentId [
	<return: #Number>

	^ anAttribute asGtExternalTextAttributeDuring: [ :aTextAttribute |
		self
			primAddAttribute: aTextAttribute
			start: aStart - 1
			end: anEnd - 1
			documentId: documentId ].
]

{ #category : 'api - attributes' }
GtTextEditorHandle >> addAttribute: anAttribute overAdornment: anAdornmentTag [
	<return: #Number>
	^ anAttribute
		asGtExternalTextAttributeDuring: [ :aTextAttribute |
			self primAddAttribute: aTextAttribute overAdornment: anAdornmentTag ]
]

{ #category : 'api - navigation' }
GtTextEditorHandle >> addCursorAtVisualPoint: aPoint [
	self
		primAddCursorAtVisualX: aPoint x
		y: aPoint y
]

{ #category : 'api - debugging' }
GtTextEditorHandle >> commandsRecorder [
	^ commandsRecorder
]

{ #category : 'api - editing' }
GtTextEditorHandle >> copySelected [
	self primCopySelected
]

{ #category : 'api - editing' }
GtTextEditorHandle >> cutSelected [
	self primCutSelected
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

{ #category : 'api - debugging' }
GtTextEditorHandle >> enableInMemoryCommandsRecorder [
	commandsRecorder := GtTextEditorInMemoryCommandsRecorder fromNativeHandle: self primCommandsRecorderSetInMemory
]

{ #category : 'api - selection' }
GtTextEditorHandle >> endSelectionAtVisualPoint [
	self primEndSelectionAtVisualPoint
]

{ #category : 'api - selection' }
GtTextEditorHandle >> extendSelectionDown [
	self primExtendSelectionDown
]

{ #category : 'api - selection' }
GtTextEditorHandle >> extendSelectionLeft [
	self primExtendSelectionLeft
]

{ #category : 'api - selection' }
GtTextEditorHandle >> extendSelectionRight [
	self primExtendSelectionRight
]

{ #category : 'api - selection' }
GtTextEditorHandle >> extendSelectionToLineEnd [
	self primExtendSelectionToLineEnd
]

{ #category : 'api - selection' }
GtTextEditorHandle >> extendSelectionToLineStart [
	self primExtendSelectionToLineStart
]

{ #category : 'api - selection' }
GtTextEditorHandle >> extendSelectionUp [
	self primExtendSelectionUp
]

{ #category : 'accessing' }
GtTextEditorHandle >> height [
	^ self primGetHeight
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> initialize [
	super initialize.
	
	commandsRecorder := nil
]

{ #category : 'api - editing' }
GtTextEditorHandle >> insertStringAtCursor: aString [
	self ffiLibrary
		newString: aString
		during: [ :aStringBox | self primInsertString: aStringBox ]
]

{ #category : 'api - editing' }
GtTextEditorHandle >> insertTabOrIndent [
	self primInsertTabOrIndent
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

{ #category : 'api - navigation' }
GtTextEditorHandle >> moveCaretsDown [
	^ self primMoveCaretsDown
]

{ #category : 'api - navigation' }
GtTextEditorHandle >> moveCaretsUp [
	^ self primMoveCaretsUp
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

{ #category : 'api - editing' }
GtTextEditorHandle >> pasteAtCarets [
	self primPaste
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primAddAttribute: anAttribute overAdornment: anAdornmentTag [
	self ffiBareCall: #(uint64 editor_handle_add_text_attribute_over_adornment(
		self,
		void* anAttribute,
		uint64 anAdornmentTag))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primAddAttribute: anAttribute start: aStart end: anEnd [
	self ffiBareCall: #(uint64 editor_handle_add_text_attribute(
		self,
		void* anAttribute,
		size_t aStart,
		size_t anEnd))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primAddAttribute: anAttribute start: aStart end: anEnd documentId: documentId [
	self ffiBareCall: #(uint64 editor_handle_add_text_attribute_with_document_validation(
		self,
		void* anAttribute,
		size_t aStart,
		size_t anEnd,
		void* documentId))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primAddCursorAtVisualX: aX y: aY [
	self ffiCall: #(void editor_handle_add_cursor_at_visual_point(
		self,
		float64 aX,
		float64 aY))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primCommandsRecorderReset [
	self ffiCall: #(void editor_handle_reset_commands_recorder(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primCommandsRecorderSetInMemory [
	^ self ffiCall: #(void* editor_handle_set_in_memory_commands_recorder(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primCopySelected [
	self ffiCall: #(void editor_handle_copy_selection(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primCreateAdornmentDynamicOffset: anAdornmentId [
	^ self ffiCall: #(void* editor_handle_make_dynamic_offset_payload(self, uint64 anAdornmentId))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primCutSelected [
	self ffiCall: #(void editor_handle_cut_selection(self))
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
GtTextEditorHandle >> primExtendSelectionDown [
	self ffiCall: #(void editor_handle_extend_selection_down(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primExtendSelectionLeft [
	self ffiCall: #(void editor_handle_extend_selection_left(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primExtendSelectionRight [
	self ffiCall: #(void editor_handle_extend_selection_right(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primExtendSelectionToLineEnd [
	self ffiCall: #(void editor_handle_extend_selection_to_line_end(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primExtendSelectionToLineStart [
	self ffiCall: #(void editor_handle_extend_selection_to_line_start(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primExtendSelectionUp [
	self ffiCall: #(void editor_handle_extend_selection_up(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primGetHeight [
	self ffiCall: #(float64 editor_handle_get_height(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primGetPhlowVTable [
	^ self ffiCall: #(void* editor_handle_phlow_vtable(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primGetUnstyledText [
	self ffiCall: #(void* editor_handle_get_unstyled_text(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primInsertString: aStringBox [
	^ self ffiCall: #(void editor_handle_insert_str(
		self,
		void* aStringBox))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primInsertTabOrIndent [
	self ffiCall: #(void editor_handle_insert_tab_or_indent(self))
]

{ #category : 'private - ffi' }
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
GtTextEditorHandle >> primMoveCaretsDown [
	self ffiCall: #(void editor_handle_move_carets_down(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primMoveCaretsUp [
	self ffiCall: #(void editor_handle_move_carets_up(self))
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

{ #category : 'private - ffi' }
GtTextEditorHandle >> primPaste [
	self ffiCall: #(void editor_handle_paste(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primQueryEditorClone [
	^ self ffiCall: #(void* editor_handle_query_editor(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primQueryMetrics [
	^ self ffiCall: #(void* editor_handle_query_metrics(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primRedo [
	self ffiCall: #(void editor_handle_redo(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primRemoveAttributeTagged: anAttributeTag [
	self ffiBareCall: #(void editor_handle_remove_text_attribute(
		self,
		uint64 anAttributeTag))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primRemoveAttributeTagged: anAttributeTag overAdornment: anAdornmentTag [
	self ffiBareCall: #(void editor_handle_remove_text_attribute_over_adornment(
		self,
		uint64 anAttributeTag,
		uint64 anAdornmentTag))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primRequestStyling: aStylingTrigger [
	self ffiCall: #(void editor_handle_request_styling(self, GtTextEditorStylingTrigger aStylingTrigger))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primResizeAdornment: anAttributeTag width: aWidth height: aHeight [
	^ self ffiCall: #(void editor_handle_resize_adornment(
		self,
		uint64 anAttributeTag,
		float64 aWidth,
		float64 aHeight))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primScrollBy: aY [
	self ffiCall: #(void editor_handle_scroll_by(self, float64 aY))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primSelectAll [
	self ffiCall: #(void editor_handle_select_all(self))
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

{ #category : 'private - ffi' }
GtTextEditorHandle >> primSetMockedTextLayouter: aGlyphSize [
	self ffiCall: #(void editor_handle_set_text_layouter_mocked(self, float64 aGlyphSize))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primSetRenderThreadWakerThunk: thunk [
	^ self ffiCall: #(void editor_handle_set_render_thread_thunk(self, void* thunk))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primSetSkiaTextLayouter [
	self ffiCall: #(void editor_handle_set_text_layouter_skia(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primSetStyledText: aGtTextEditorExternalText documentId: aDocumentId [
	self ffiBareCall: #(void editor_handle_set_styled_text(self, void* aGtTextEditorExternalText, void* aDocumentId))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primSetTabWidth: aTabWidth [
	self ffiBareCall: #(void editor_handle_set_tab_width(self, size_t aTabWidth))
]

{ #category : 'private - ffi' }
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
GtTextEditorHandle >> primUndo [
	self ffiCall: #(void editor_handle_undo(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primUnindent [
	self ffiCall: #(void editor_handle_unindent(self))
]

{ #category : 'private - ffi' }
GtTextEditorHandle >> primUpdateSelectionAtVisualX: aX y: aY [
	self ffiCall: #(void editor_handle_update_selection_at_visual_point(
		self,
		float64 aX,
		float64 aY))
]

{ #category : 'api - editing' }
GtTextEditorHandle >> redo [
	self primRedo
]

{ #category : 'api - attributes' }
GtTextEditorHandle >> removeAttributeTagged: anAttributeTag [
	self
			primRemoveAttributeTagged: anAttributeTag
]

{ #category : 'api - attributes' }
GtTextEditorHandle >> removeAttributeTagged: anAttributeTag overAdornment: anAdornmentTag [
	self
			primRemoveAttributeTagged: anAttributeTag
			overAdornment: anAdornmentTag
]

{ #category : 'api - styling' }
GtTextEditorHandle >> requestStyling: aStylingTrigger [
	self primRequestStyling: aStylingTrigger
]

{ #category : 'api - debugging' }
GtTextEditorHandle >> resetCommandsRecorder [
	self primCommandsRecorderReset.
	commandsRecorder := nil
]

{ #category : 'as yet unclassified' }
GtTextEditorHandle >> resizeAdornment: anAttributeTag extent: aPoint [
	self
		primResizeAdornment: anAttributeTag
		width: aPoint x
		height: aPoint y
]

{ #category : 'api - scrolling' }
GtTextEditorHandle >> scrollBy: aY [
	self primScrollBy: aY
]

{ #category : 'api - selection' }
GtTextEditorHandle >> selectAll [
	self primSelectAll
]

{ #category : 'initialization' }
GtTextEditorHandle >> setRenderThreadWakerThunk: aWindow [
	self primSetRenderThreadWakerThunk: aWindow
]

{ #category : 'api - selection' }
GtTextEditorHandle >> startSelectionAtVisualPoint: aPoint [
	self primStartSelectionAtVisualX: aPoint x y: aPoint y
]

{ #category : 'accessing' }
GtTextEditorHandle >> styledText: aGtTextEditorExternalText documentId: aDocumentId [
	self primSetStyledText: aGtTextEditorExternalText documentId: aDocumentId
]

{ #category : 'accessing' }
GtTextEditorHandle >> tabWidth: aNumber [
	self primSetTabWidth: aNumber
]

{ #category : 'accessing' }
GtTextEditorHandle >> text: aGtTextEditorExternalText [
	self primSetText: aGtTextEditorExternalText
]

{ #category : 'api - editing' }
GtTextEditorHandle >> undo [
	self primUndo
]

{ #category : 'api - editing' }
GtTextEditorHandle >> unindent [
	self primUnindent
]

{ #category : 'api - debugging' }
GtTextEditorHandle >> unstyledText [
	^ GtTextEditorExternalText fromNativeHandle: self primGetUnstyledText
]

{ #category : 'api - selection' }
GtTextEditorHandle >> updateSelectionAtVisualPoint: aPoint [
	self primUpdateSelectionAtVisualX: aPoint x y: aPoint y
]

{ #category : 'api - debugging' }
GtTextEditorHandle >> useMockedTextLayouter: aGlyphSize [
	self primSetMockedTextLayouter: aGlyphSize
]

{ #category : 'api - debugging' }
GtTextEditorHandle >> useSkiaTextLayouter [
	self primSetSkiaTextLayouter
]
