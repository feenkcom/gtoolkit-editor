"
Examples proving GtTextEditorElement dispatches BrTextEditorCursorChangedEvent with a character offset (not the rust editor's internal byte offset) when the active caret moves.
"
Class {
	#name : 'GtTextEditorElementActiveCaretMovedExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples' }
GtTextEditorElementActiveCaretMovedExamples >> activeCaretMovedEventReportsCharacterOffsetNotByteOffset [
	"'héllo' has a 2-byte 'e-acute' in UTF-8: byte offset 3 and character
	offset 2 both point right after the accented character, but they are
	different numbers. BrTextEditorCursor indexes text by character (like a
	plain String), so the dispatched event's cursor must land at character
	offset 2, not at the rust editor's internal byte offset 3.
	(The setup move below may itself still be in flight on the async FFI
	queue when we subscribe, so more than one event can arrive; only the
	final position after #moveCursorRight is asserted.)"
	<gtExample>
	| anElement events |
	anElement := self elementWithText: 'héllo'.
	anElement moveCursorTo: 1.

	events := OrderedCollection new.
	anElement when: BrTextEditorCursorChangedEvent do: [ :anEvent | events add: anEvent ].

	anElement moveCursorRight.
	self waitUntil: [ events isNotEmpty ] on: anElement.

	self assert: events last cursors positions asArray equals: #(2).

	^ anElement
]

{ #category : 'support' }
GtTextEditorElementActiveCaretMovedExamples >> elementWithText: aString [
	<gtExample>
	| anElement |
	anElement := GtTextEditorElement new.
	anElement exact: 200 @ 200.
	anElement text: aString asRopedText.
	^ anElement
]

{ #category : 'support' }
GtTextEditorElementActiveCaretMovedExamples >> waitUntil: aBlock on: anElement [
	"The rust-backed editor delivers embedder messages (including
	BrTextEditorCursorChangedEvent) asynchronously through a polled FFI
	queue. Repeatedly drain it and give the native side a moment to catch up
	before asserting on dispatched events, rather than assuming a single poll
	right after the triggering call is enough."
	| deadline |
	deadline := DateAndTime now + 2 seconds.
	[ anElement pollEditorMessages. aBlock value or: [ DateAndTime now > deadline ] ]
		whileFalse: [ (Delay forMilliseconds: 20) wait ]
]
