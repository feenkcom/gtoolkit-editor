"
I exemplify the `Debug` phlow view of ${class:GtTextEditorHandle}$.

The view reports how many commands and messages the in-memory recorders captured, and each row spawns the recorder it counts, where the Rust-defined `Commands`, `Adornment Commands`, `Messages` and `Adornment Messages` views live.

The counts are read from those Rust views, so the recorded commands and messages only appear once the editor has processed them. The examples drain the editor with ${method:GtTextEditorHandleDebugViewExamples>>#waitUntil:on:}$ rather than asserting right after the triggering call.
"
Class {
	#name : 'GtTextEditorHandleDebugViewExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples' }
GtTextEditorHandleDebugViewExamples >> commandsRow [
	<gtExample>
	<return: #GtPhlowDetailsRow>
	| aHandle aRow aRecorder theParts |
	aHandle := self elementWithRecordedEdits privateEditorHandle.
	aRow := (self debugRowsOf: aHandle) first.
	self assert: aRow name equals: 'Commands'.

	aRecorder := aRow valueComputation value.
	self assert: aRecorder class equals: GtTextEditorInMemoryCommandsRecorder.

	"The exact counts depend on how much the editor processed, so the shape is asserted
	and only the recorded commands are required to be there at all."
	theParts := (self textOfRow: aRow) substrings: ' '.
	self assert: theParts size equals: 5.
	self assert: (theParts at: 1) asNumber > 0.
	self assert: (theParts at: 2) equals: 'commands,'.
	self assert: (theParts at: 3) asNumber >= 0.
	self assert: (theParts at: 4) equals: 'adornment'.
	self assert: (theParts at: 5) equals: 'commands'.
	^ aRow
]

{ #category : 'private' }
GtTextEditorHandleDebugViewExamples >> debugRowsOf: aHandle [
	"Answer the rows of the Debug view of aHandle."
	<return: #Collection of: #GtPhlowDetailsRow>
	^ (aHandle gtDebugFor: GtPhlowView empty) phlowDetailRows
]

{ #category : 'examples' }
GtTextEditorHandleDebugViewExamples >> debugView [
	<gtExample>
	<return: #GtPhlowDetailsView>
	| aHandle aView |
	aHandle := self elementWithRecordedEdits privateEditorHandle.
	aView := aHandle gtDebugFor: GtPhlowView empty.
	self assert: aView class equals: GtPhlowDetailsView.
	self assert: aView title equals: 'Debug'.
	self
		assert: (aView phlowDetailRows collect: [ :eachRow | eachRow name ]) asArray
		equals: #('Commands' 'Messages').
	^ aView
]

{ #category : 'examples' }
GtTextEditorHandleDebugViewExamples >> elementWithRecordedEdits [
	"An editor element whose handle recorded a text insertion and a caret move."
	<gtExample>
	<return: #GtTextEditorElement>
	| anElement aHandle |
	anElement := self elementWithoutRecorders.
	aHandle := anElement privateEditorHandle.
	aHandle enableInMemoryCommandsRecorder.

	aHandle insertStringAtCursor: 'XYZ'.
	anElement moveCaretsUp.

	self
		waitUntil: [ ((self textOfRow: (self debugRowsOf: aHandle) first) beginsWith: '0 ') not ]
		on: anElement.
	^ anElement
]

{ #category : 'examples' }
GtTextEditorHandleDebugViewExamples >> elementWithoutRecorders [
	"An editor element whose handle never had the in-memory recorders enabled."
	<gtExample>
	<return: #GtTextEditorElement>
	| anElement |
	anElement := GtTextEditorElement new.
	anElement exact: 200 @ 200.
	anElement text: 'abcd' asRopedText.
	^ anElement
]

{ #category : 'examples' }
GtTextEditorHandleDebugViewExamples >> emptyDebugViewWithoutRecorders [
	<gtExample>
	<return: #GtPhlowEmptyView>
	| aHandle aView |
	aHandle := self elementWithoutRecorders privateEditorHandle.
	aView := aHandle gtDebugFor: GtPhlowView empty.
	self assert: aView class equals: GtPhlowEmptyView.
	^ aView
]

{ #category : 'examples' }
GtTextEditorHandleDebugViewExamples >> messagesRow [
	<gtExample>
	<return: #GtPhlowDetailsRow>
	| aHandle aRow aRecorder theParts |
	aHandle := self elementWithRecordedEdits privateEditorHandle.
	aRow := (self debugRowsOf: aHandle) second.
	self assert: aRow name equals: 'Messages'.

	aRecorder := aRow valueComputation value.
	self assert: aRecorder class equals: GtTextEditorInMemoryToEmbedderCommandsRecorder.

	theParts := (self textOfRow: aRow) substrings: ' '.
	self assert: theParts size equals: 5.
	self assert: (theParts at: 1) asNumber > 0.
	self assert: (theParts at: 2) equals: 'messages,'.
	self assert: (theParts at: 3) asNumber >= 0.
	self assert: (theParts at: 4) equals: 'adornment'.
	self assert: (theParts at: 5) equals: 'messages'.
	^ aRow
]

{ #category : 'examples' }
GtTextEditorHandleDebugViewExamples >> rustPhlowViewOfUnknownTitleIsNil [
	<gtExample>
	<return: #GtTextEditorHandle>
	| aHandle aRecorder |
	aHandle := self elementWithRecordedEdits privateEditorHandle.
	aRecorder := (self debugRowsOf: aHandle) first valueComputation value.
	self assert: (aHandle rustPhlowViewOf: aRecorder titled: 'There is no such view') isNil.
	self assert: (aHandle rustViewItemsCountOf: aRecorder titled: 'There is no such view') equals: 0.
	^ aHandle
]

{ #category : 'examples' }
GtTextEditorHandleDebugViewExamples >> rustPhlowViewTitlesResolve [
	"The counts are looked up by the titles the Rust side gives its phlow views.
	Renaming a view there would silently make the Debug view report zero, so each
	title is required to resolve to a list view."
	<gtExample>
	<return: #Array>
	| aHandle theRows aCommandsRecorder aMessagesRecorder theTitles |
	aHandle := self elementWithRecordedEdits privateEditorHandle.
	theRows := self debugRowsOf: aHandle.
	aCommandsRecorder := theRows first valueComputation value.
	aMessagesRecorder := theRows second valueComputation value.
	theTitles := {
		aCommandsRecorder -> 'Commands'.
		aCommandsRecorder -> 'Adornment Commands'.
		aMessagesRecorder -> 'Messages'.
		aMessagesRecorder -> 'Adornment Messages' }.
	theTitles do: [ :eachAssociation |
		| aRustView |
		aRustView := aHandle
				rustPhlowViewOf: eachAssociation key
				titled: eachAssociation value.
		self
			assert: aRustView isNotNil
			description: [ 'No rust phlow view titled {1}' format: { eachAssociation value } ].
		self assert: aRustView class equals: GtRustPhlowListView ].
	^ theTitles
]

{ #category : 'private' }
GtTextEditorHandleDebugViewExamples >> textOfRow: aRow [
	"Answer the text aRow displays for the object it spawns."
	<return: #String>
	^ aRow textComputation value: aRow valueComputation value
]

{ #category : 'private' }
GtTextEditorHandleDebugViewExamples >> waitUntil: aBlock on: anElement [
	"The rust-backed editor processes commands and delivers embedder messages
	asynchronously through a polled FFI queue. Repeatedly drain it and give the native
	side a moment to catch up before asserting on recorded counts, rather than assuming
	the recording has happened by the time the triggering call returns."
	| aDeadline |
	aDeadline := DateAndTime now + 2 seconds.
	[ anElement pollEditorMessages. aBlock value or: [ DateAndTime now > aDeadline ] ]
		whileFalse: [ (Delay forMilliseconds: 20) wait ]
]
