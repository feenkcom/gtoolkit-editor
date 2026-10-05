"
I exemplify ${method:GtTextEditorExternalText>>#documentId}$, the rust side document id of a text.

The point of these examples is that a document id has two numbering spaces that look alike. A ${class:BlText}$ built in Pharo carries a Pharo side id, while a ${class:GtTextEditorExternalText}$ carries one the rust side assigned when the text was created. Both print as `DocumentId(id: ..., revision: ...)`, so they are easy to mistake for each other, and what they are and are not comparable to is worth pinning down.

I skip when the editor library is unavailable, as the other rust editor examples do.
"
Class {
	#name : 'GtTextEditorExternalTextExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples' }
GtTextEditorExternalTextExamples >> aBlTextDocumentIdIsNotARustDocumentId [
	"The trap this accessor exists to expose. ${class:BlText}$ and ${class:GtTextEditorExternalText}$ both
	answer a `documentId` that prints the same way, but a BlText built in Pharo is numbered by Pharo while
	the converted rust text is numbered by rust. Comparing the two is meaningless, and before this
	accessor existed there was no way to see the rust one."
	<gtExample>
	<return: #GtTextEditorTextSetSignal>
	| aTextSet |
	self ifRenderedEditorCannotRunDo: [ ^ GtTextEditorTextSetSignal new ].
	aTextSet := self recordedTextSetSignalOfARenderedEditor.

	self assert: aTextSet sourceDocumentId isNotNil.
	self assert: aTextSet targetDocumentId isNotNil.
	self assert: (aTextSet sourceDocumentId = aTextSet targetDocumentId) not.
	^ aTextSet
]

{ #category : 'private' }
GtTextEditorExternalTextExamples >> ifLibraryIsMissingDo: aBlock [
	"Guard the examples that need only the library loaded, not a window.

	Deliberately not ${method:GtTextEditorLibrary class>>#canRunExamples}$, which also requires a windowing
	event loop. A text is a plain rust object with no element, no space and no layout, so it can be
	exercised in a headless image, which is how examples run on CI. Using the stricter guard would skip
	these exactly where they are most worth running. A missing library is still reported on stdout by the
	element based examples in the same run."
	GtTextEditorLibrary uniqueInstance hasModule ifFalse: [ ^ aBlock value ].
	^ nil
]

{ #category : 'private' }
GtTextEditorExternalTextExamples >> ifRenderedEditorCannotRunDo: aBlock [
	"Guard the examples that render an editor, which need a windowing event loop as well as the library."
	GtTextEditorLibrary canRunExamples ifFalse: [ ^ aBlock value ].
	^ nil
]

{ #category : 'examples' }
GtTextEditorExternalTextExamples >> insertingIntoATextAdvancesItsRevision [
	"The revision tracks content changes, which is the whole basis of the staleness comparison: the text
	id stays, the revision moves."
	<gtExample>
	<return: #Array>
	| theIds |
	self ifLibraryIsMissingDo: [ ^ #() ].
	theIds := GtTextEditorExternalText
			fromString: 'hello'
			during: [ :aText | | beforeId |
				beforeId := aText documentId.
				aText insertString: ' world' at: aText size.
				{beforeId. aText documentId} ].

	self assert: (theIds first) textId equals: (theIds second) textId.
	self assert: (theIds second) revisionId > (theIds first) revisionId.
	^ theIds
]

{ #category : 'private' }
GtTextEditorExternalTextExamples >> recordedTextSetSignalOfARenderedEditor [
	"Answer the one text set signal of a freshly rendered editor, with both of its document ids filled in."
	<return: #GtTextEditorTextSetSignal>
	| aRecorder aScripter |
	aRecorder := GtTextEditorTimelineRecorder new.
	aRecorder isEnabled: true.
	aScripter := self scripterWithRenderedEditorRecordedBy: aRecorder.
	^ ((aRecorder timelineFor: aScripter element)
		detect: [ :anEntry | anEntry signal class == GtTextEditorTextSetSignal ]) signal
]

{ #category : 'private' }
GtTextEditorExternalTextExamples >> scripterWithRenderedEditorRecordedBy: aRecorder [
	"Answer a scripter holding a rendered rust editor, with aRecorder collecting the whole run.

	The wait step is what makes this usable in an example: setting the text only starts the work, and the
	styling and the layout finish afterwards."
	<return: #BlScripter>
	^ aRecorder
		runDuring: [ | anElement aScripter |
			anElement := GtTextEditorElement new.
			anElement exact: 400 @ 200.
			anElement text: 'GtTextEditorElement >> #foo ^ 42' asRopedText.
			aScripter := BlScripter new element: anElement.
			aScripter wait
				waitRustEditorRendered: anElement pulseDuring: 5 seconds;
				play.
			aScripter ]
]

{ #category : 'examples' }
GtTextEditorExternalTextExamples >> separatelyBuiltTextsAreDifferentDocuments [
	"Equal contents are not one document. The id identifies the text object, not what it says, which is
	what lets the editor tell a styled text computed for an older text from one computed for this one."
	<gtExample>
	<return: #Array>
	| oneId anotherId |
	self ifLibraryIsMissingDo: [ ^ #() ].
	oneId := GtTextEditorExternalText fromString: 'hello world' during: [ :aText | aText documentId ].
	anotherId := GtTextEditorExternalText fromString: 'hello world' during: [ :aText | aText documentId ].

	self assert: oneId isNotNil.
	self assert: anotherId isNotNil.
	self assert: oneId textId ~= anotherId textId.
	self assert: (oneId = anotherId) not.
	^ {oneId. anotherId}
]

{ #category : 'examples' }
GtTextEditorExternalTextExamples >> textFromAStringReportsItsOwnDocumentId [
	"A text is assigned a document id when it is created, so one built from a string already has one."
	<gtExample>
	<return: #GtTextEditorDocumentId>
	| aDocumentId |
	self ifLibraryIsMissingDo: [ ^ GtTextEditorDocumentId new ].
	aDocumentId := GtTextEditorExternalText
			fromString: 'hello world'
			during: [ :aText | aText documentId ].

	self assert: aDocumentId isNotNil.
	self assert: aDocumentId textId > 0.

	"Only an insertion or a deletion advances the revision, and a text built in one step has had
	neither, so a fresh text is always at the initial revision."
	self assert: aDocumentId revisionId equals: 1.
	^ aDocumentId
]

{ #category : 'examples' }
GtTextEditorExternalTextExamples >> theEditorAdoptsTheDocumentIdOfTheTextItIsGiven [
	"The id the editor reports in a styling request is the one the converted rust text already carried, not
	one the editor assigned for itself.

	This is what makes the staleness comparison meaningful from Pharo: an id read off a rust text can be
	compared with the ids the editor reports, because they are the same id."
	<gtExample>
	<return: #GtTextEditorDocumentId>
	| aRecorder aScripter theEntries aTextSet theRequestedIds |
	self ifRenderedEditorCannotRunDo: [ ^ GtTextEditorDocumentId new ].
	aRecorder := GtTextEditorTimelineRecorder new.
	aRecorder isEnabled: true.
	aScripter := self scripterWithRenderedEditorRecordedBy: aRecorder.
	theEntries := aRecorder timelineFor: aScripter element.

	aTextSet := (theEntries detect: [ :anEntry | anEntry signal class == GtTextEditorTextSetSignal ]) signal.
	self assert: aTextSet targetDocumentId isNotNil.

	theRequestedIds := theEntries
			select: [ :anEntry | anEntry signal class == GtTextEditorStylingRequestedSignal ]
			thenCollect: [ :anEntry | anEntry signal documentId ].
	self assert: theRequestedIds isNotEmpty.
	self assert: (theRequestedIds includes: aTextSet targetDocumentId).
	^ aTextSet targetDocumentId
]
