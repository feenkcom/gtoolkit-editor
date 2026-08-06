Class {
	#name : 'GtTextEditorElementCursorBoundaryExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples' }
GtTextEditorElementCursorBoundaryExamples >> cursorReachedBoundaryEventDoesNotFireWhenMovingWithinDocument [
	"Moving the cursor up from the middle line onto the first line is a
	regular move, not a boundary, so no event should be dispatched."
	<gtExample>
	| anElement events |
	anElement := self elementWithText: 'abcd', String lf, 'wxyz', String lf, '1234'.
	anElement moveCursorTo: 7.

	events := OrderedCollection new.
	anElement when: BrTextEditorCursorReachedBoundaryEvent do: [ :anEvent | events add: anEvent ].

	anElement moveCaretsUp.
	self waitUntil: [ false ] on: anElement.

	self assert: events isEmpty.

	^ anElement
]

{ #category : 'examples' }
GtTextEditorElementCursorBoundaryExamples >> cursorReachedBoundaryEventFiresOnArrowDownAtLastLine [
	"A single-line document has no line below its only line, so moving the
	caret down must dispatch a bottom BrTextEditorCursorReachedBoundaryEvent."
	<gtExample>
	| anElement events |
	anElement := self elementWithText: 'abcd'.
	events := OrderedCollection new.
	anElement when: BrTextEditorCursorReachedBoundaryEvent do: [ :anEvent | events add: anEvent ].

	anElement moveCaretsDown.
	self waitUntil: [ events isNotEmpty ] on: anElement.

	self assert: events size equals: 1.
	self assert: events first isBottom.

	^ anElement
]

{ #category : 'examples' }
GtTextEditorElementCursorBoundaryExamples >> cursorReachedBoundaryEventFiresOnArrowUpAtFirstLine [
	"A single-line document has no line above its only line, so moving the
	caret up must dispatch a top BrTextEditorCursorReachedBoundaryEvent, the
	same event Brick-Editor dispatches, so Lepiter's snippet navigation keeps
	working with the rust-backed editor."
	<gtExample>
	| anElement events |
	anElement := self elementWithText: 'abcd'.
	events := OrderedCollection new.
	anElement when: BrTextEditorCursorReachedBoundaryEvent do: [ :anEvent | events add: anEvent ].

	anElement moveCaretsUp.
	self waitUntil: [ events isNotEmpty ] on: anElement.

	self assert: events size equals: 1.
	self assert: events first isTop.

	^ anElement
]

{ #category : 'examples' }
GtTextEditorElementCursorBoundaryExamples >> cursorReachedBoundaryEventReportsCharacterOffsetNotByteOffset [
	"'héllo' has a 2-byte 'e-acute' in UTF-8: byte offset 4 and character
	offset 3 both point at the second 'l', but they are different numbers.
	BrTextEditorCursor indexes text by character (like a plain String), so
	the dispatched event's cursor must land at character offset 3, not at
	the rust editor's internal byte offset 4."
	<gtExample>
	| anElement events |
	anElement := self elementWithText: 'héllo'.
	anElement moveCursorTo: 3.

	events := OrderedCollection new.
	anElement when: BrTextEditorCursorReachedBoundaryEvent do: [ :anEvent | events add: anEvent ].

	anElement moveCaretsUp.
	self waitUntil: [ events isNotEmpty ] on: anElement.

	self assert: events size equals: 1.
	self assert: events first cursor positions asArray equals: #(3).

	^ anElement
]

{ #category : 'examples' }
GtTextEditorElementCursorBoundaryExamples >> elementWithText: aString [
	<gtExample>
	| anElement |
	anElement := GtTextEditorElement new.
	anElement exact: 200 @ 200.
	anElement text: aString asRopedText.
	^ anElement
]

{ #category : 'private' }
GtTextEditorElementCursorBoundaryExamples >> waitUntil: aBlock on: anElement [
	"The rust-backed editor delivers embedder messages (including
	BrTextEditorCursorReachedBoundaryEvent) asynchronously through a polled FFI
	queue. Repeatedly drain it and give the native side a moment to catch up
	before asserting on dispatched events, rather than assuming a single poll
	right after the triggering call is enough."
	| deadline |
	deadline := DateAndTime now + 2 seconds.
	[ anElement pollEditorMessages. aBlock value or: [ DateAndTime now > deadline ] ]
		whileFalse: [ (Delay forMilliseconds: 20) wait ]
]
