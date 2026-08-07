Class {
	#name : 'GtTextEditorElementInsertLineEndingExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'support' }
GtTextEditorElementInsertLineEndingExamples >> elementWithText: aString [
	<gtExample>
	| anElement |
	anElement := GtTextEditorElement new.
	anElement exact: 200 @ 200.
	anElement text: aString asRopedText.
	^ anElement
]

{ #category : 'examples' }
GtTextEditorElementInsertLineEndingExamples >> insertLineEndingAtCursorInheritsIndentationOfPreviousLine [
	"Same behavior as BrTextEditorModel>>#insertLineEndingAtCursor, exercised through
	the rust-backed element: Enter at the end of an indented line inserts a platform
	line ending and carries the leading whitespace over to the new line."
	<gtExample>
	<return: #GtTextEditorElement>
	| indentedLine anElement |
	indentedLine := String tab , 'Hello'.
	anElement := self elementWithText: indentedLine.
	anElement moveCursorToEnd.

	anElement insertLineEndingAtCursor.

	self
		waitUntil: [ anElement unstyledText asString ~= indentedLine ]
		on: anElement.

	self
		assert: anElement unstyledText asString
		equals: indentedLine , OSPlatform current lineEnding , String tab.

	^ anElement
]

{ #category : 'examples' }
GtTextEditorElementInsertLineEndingExamples >> insertLineEndingAtCursorWithoutIndentationInsertsPlatformLineEnding [
	<gtExample>
	<return: #GtTextEditorElement>
	| anElement |
	anElement := self elementWithText: 'Hello'.
	anElement moveCursorToEnd.

	anElement insertLineEndingAtCursor.

	self
		waitUntil: [ anElement unstyledText asString ~= 'Hello' ]
		on: anElement.

	self
		assert: anElement unstyledText asString
		equals: 'Hello' , OSPlatform current lineEnding.

	^ anElement
]

{ #category : 'support' }
GtTextEditorElementInsertLineEndingExamples >> waitUntil: aBlock on: anElement [
	"The rust-backed editor applies edits synchronously, but reading them back
	goes through the same polled FFI queue as other embedder messages. Repeatedly
	drain it and give the native side a moment to catch up before asserting."
	| deadline |
	deadline := DateAndTime now + 2 seconds.
	[ anElement pollEditorMessages. aBlock value or: [ DateAndTime now > deadline ] ]
		whileFalse: [ (Delay forMilliseconds: 20) wait ]
]
