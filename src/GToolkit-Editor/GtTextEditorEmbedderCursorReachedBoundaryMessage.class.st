"
I am sent by the rust editor when a plain (non-selection-extending) vertical caret move could not find a line above/below the caret, i.e. the caret is already on the first or last visual line of the document.
"
Class {
	#name : 'GtTextEditorEmbedderCursorReachedBoundaryMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private' }
GtTextEditorEmbedderCursorReachedBoundaryMessage class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_cursor_reached_boundary_message_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorEmbedderCursorReachedBoundaryMessage >> cursorCharacterOffset [
	"Answer the caret's position as a 0-based character offset (same convention as GtTextEditorElement>>#moveCursorTo: / #caretOffset), not a byte offset. Use this — not #cursorRawOffset — to build a BrTextEditorCursor, which indexes text by character."

	^ self primGetCursorCharacterOffset
]

{ #category : 'accessing' }
GtTextEditorEmbedderCursorReachedBoundaryMessage >> cursorRawOffset [
	^ self primGetCursorRawOffset
]

{ #category : 'accessing' }
GtTextEditorEmbedderCursorReachedBoundaryMessage >> edge [
	<return: #GtTextEditorScrollEdgeType>

	^ self primGetEdge
]

{ #category : 'testing' }
GtTextEditorEmbedderCursorReachedBoundaryMessage >> isBottom [
	^ self edge = GtTextEditorScrollEdgeType Bottom
]

{ #category : 'testing' }
GtTextEditorEmbedderCursorReachedBoundaryMessage >> isTop [
	^ self edge = GtTextEditorScrollEdgeType Top
]

{ #category : 'private' }
GtTextEditorEmbedderCursorReachedBoundaryMessage >> primGetCursorCharacterOffset [
	^ self ffiCall: #(size_t to_embedder_cursor_reached_boundary_message_get_cursor_character_offset(self))
]

{ #category : 'private' }
GtTextEditorEmbedderCursorReachedBoundaryMessage >> primGetCursorRawOffset [
	^ self ffiCall: #(size_t to_embedder_cursor_reached_boundary_message_get_cursor_raw_offset(self))
]

{ #category : 'private' }
GtTextEditorEmbedderCursorReachedBoundaryMessage >> primGetEdge [
	^ self ffiCall: #(GtTextEditorScrollEdgeType to_embedder_cursor_reached_boundary_message_get_edge(self))
]

{ #category : 'api' }
GtTextEditorEmbedderCursorReachedBoundaryMessage >> sendTo: anObject [
	anObject onEditorCursorReachedBoundary: self
]
