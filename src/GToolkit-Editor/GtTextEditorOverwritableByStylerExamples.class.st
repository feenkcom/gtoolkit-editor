"
I exemplify that `isOverwritableByStyler` survives the crossing from Pharo to the rust side.

The flag is the embedder's statement that an attribute is its own and no styling pass may remove it. ${class:BlRunRopedText}$`>>unstyle:to:` honours it for every attribute kind, so the Brick editor keeps such an attribute through a restyle. The rust editor has to behave the same way, and for that the flag has to arrive at all.

It did not, for replacing attributes. `gtExternalTextConfigureAppendingAttribute:` forwarded it and there was no replacing counterpart, so an attribute the embedder had marked as its own arrived overwritable and the next styling pass removed it. That is what made `GtPharoRenameSelectorModelExamples>>#rustScripterEditorWithThreeKeywordsMethod` lose 6 of its 15 adornments whenever a styling pass landed after the install.

I observe the crossing through the in-memory commands recorder, which is the only channel that shows what rust received: there is no getter for the flag on the rust side. That means matching on a rust `Debug` string, which is brittle by nature, so I match only on the two substrings that carry the meaning.

I skip when the editor library is unavailable, as the other rust editor examples do.
"
Class {
	#name : 'GtTextEditorOverwritableByStylerExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'private' }
GtTextEditorOverwritableByStylerExamples >> addTo: anElement adornment: anAlignmentBlock overwritable: isOverwritable [
	"Add one adornment attribute to anElement, built by anAlignmentBlock and flagged as asked."
	| anAttribute |
	anAttribute := BrTextAdornmentAttribute new.
	anAlignmentBlock value: anAttribute.
	isOverwritable
		ifTrue: [ anAttribute beOverwritableByStyler ]
		ifFalse: [ anAttribute beNotOverwritableByStyler ].
	self assert: anAttribute isOverwritableByStyler equals: isOverwritable.

	anElement
		addAttribute: anAttribute
		overRange: (BrTextCharacterRange start: 2 end: 4 documentId: anElement text documentId).
	^ anAttribute
]

{ #category : 'private' }
GtTextEditorOverwritableByStylerExamples >> ifRenderedEditorCannotRunDo: aBlock [
	"These examples render an editor, so they need a windowing event loop as well as the library."
	GtTextEditorLibrary canRunExamples ifFalse: [ ^ aBlock value ].
	^ nil
]

{ #category : 'private' }
GtTextEditorOverwritableByStylerExamples >> recordedAttributeCommandsOf: anElement [
	"Answer the AddTextAttribute commands anElement has sent, oldest first, as recorded strings."
	<return: #Collection>
	^ (anElement privateEditorHandle recordersSnapshotLabeled: 'overwritable by styler')
		commands select: [ :eachLine | eachLine beginsWith: 'AddTextAttribute' ]
]

{ #category : 'private' }
GtTextEditorOverwritableByStylerExamples >> renderedEditorWithRecorder [
	"Answer a rendered rust editor recording the commands it sends.

	The wait step is what makes this usable in an example: setting the text only starts the work."
	<return: #GtTextEditorElement>
	| anElement aScripter |
	anElement := GtTextEditorElement new.
	anElement exact: 400 @ 200.
	anElement privateEditorHandle enableInMemoryCommandsRecorder.
	anElement text: 'abcdefghij' asRopedText.
	aScripter := BlScripter new element: anElement.
	aScripter wait
		waitRustEditorRendered: anElement pulseDuring: 5 seconds;
		play.
	^ anElement
]

{ #category : 'examples' }
GtTextEditorOverwritableByStylerExamples >> theFlagCrossesForAReplacingAttribute [
	"The defect this example exists for: the flag was dropped on the way to rust for a replacing
	attribute, so an adornment the embedder owned arrived overwritable and the next styling pass removed
	it. Both directions are asserted, because a fix that always sends `false` would be no better."
	<gtExample>
	<return: #Collection>
	| anElement theCommands |
	self ifRenderedEditorCannotRunDo: [ ^ #() ].
	anElement := self renderedEditorWithRecorder.

	self addTo: anElement adornment: [ :anAttribute | anAttribute beReplace ] overwritable: false.
	self addTo: anElement adornment: [ :anAttribute | anAttribute beReplace ] overwritable: true.

	theCommands := self recordedAttributeCommandsOf: anElement.
	self assert: theCommands size equals: 2.
	self assert: (theCommands allSatisfy: [ :each | each includesSubstring: 'Replacing' ]).

	self
		assert: (theCommands first includesSubstring: 'is_overwritable_by_styler: false');
		assert: (theCommands first includesSubstring: 'is_overwritable_by_styler: true') not.
	self
		assert: (theCommands second includesSubstring: 'is_overwritable_by_styler: true');
		assert: (theCommands second includesSubstring: 'is_overwritable_by_styler: false') not.
	^ theCommands
]

{ #category : 'examples' }
GtTextEditorOverwritableByStylerExamples >> theFlagCrossesForAnAppendingAttribute [
	"The appending side always carried the flag. Asserted so the two sides cannot drift apart again: the
	bug was precisely that one of them did and the other did not."
	<gtExample>
	<return: #Collection>
	| anElement theCommands |
	self ifRenderedEditorCannotRunDo: [ ^ #() ].
	anElement := self renderedEditorWithRecorder.

	self addTo: anElement adornment: [ :anAttribute | anAttribute beAppend ] overwritable: false.
	self addTo: anElement adornment: [ :anAttribute | anAttribute beAppend ] overwritable: true.

	theCommands := self recordedAttributeCommandsOf: anElement.
	self assert: theCommands size equals: 2.
	self assert: (theCommands allSatisfy: [ :each | each includesSubstring: 'Appending' ]).

	self assert: (theCommands first includesSubstring: 'is_overwritable_by_styler: false').
	self assert: (theCommands second includesSubstring: 'is_overwritable_by_styler: true').
	^ theCommands
]
