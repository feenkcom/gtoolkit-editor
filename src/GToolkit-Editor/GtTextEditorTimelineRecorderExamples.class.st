"
I exemplify ${class:GtTextEditorTimelineRecorder}$.

I drive the editor through a ${class:BlScripter}$ and wait with `waitRustEditorRendered:pulseDuring:`, because the rust editor works asynchronously and an example that asserts right after setting the text asserts on a half finished run.

I skip when the editor library is unavailable, as the other rust editor examples do.
"
Class {
	#name : 'GtTextEditorTimelineRecorderExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples' }
GtTextEditorTimelineRecorderExamples >> defaultSignalClassesExcludeTheContextStackStorm [
	"GtTextEditorSignal is a ContextStackSignal whose layout, measure and request layout
	subclasses fire continuously for every live editor in the image, each capturing a full call
	stack. Recording it makes the image unusable, so the defaults have to stay narrow."
	<gtExample>
	<return: #Collection>
	| theClasses |
	theClasses := GtTextEditorTimelineRecorder new signalClasses.
	self assert: theClasses isNotEmpty.
	self assert: (theClasses includes: GtTextEditorSignal) not.
	theClasses
		do: [ :eachClass |
			self assert: (eachClass includesBehavior: GtTextEditorLayoutSignal) not ].
	self assert: (theClasses includes: GtTextEditorStylingRequestedSignal).
	self assert: (theClasses includes: GtTextEditorStyledTextAppliedSignal).
	^ theClasses
]

{ #category : 'examples' }
GtTextEditorTimelineRecorderExamples >> emptyRecorder [
	<gtExample>
	<return: #GtTextEditorTimelineRecorder>
	| aRecorder |
	aRecorder := GtTextEditorTimelineRecorder new.
	self assert: aRecorder timeline isEmpty.
	self assert: aRecorder memoryLogger isRunning not.
	^ aRecorder
]

{ #category : 'private' }
GtTextEditorTimelineRecorderExamples >> ifLibEditorIsMissingDo: aBlock [
	GtTextEditorLibrary canRunExamples ifFalse: [ ^ aBlock value ].
	^ nil
]

{ #category : 'examples' }
GtTextEditorTimelineRecorderExamples >> recordsAnnouncementsOfAGivenAnnouncer [
	"The recorder subscribes generically, so it records an announcer it knows nothing about."
	<gtExample>
	<return: #GtTextEditorTimelineRecorder>
	| aRecorder anAnnouncer theEntries |
	anAnnouncer := Announcer new.
	aRecorder := GtTextEditorTimelineRecorder new.
	aRecorder observeAnnouncer: anAnnouncer labeled: 'test announcer'.
	aRecorder runDuring: [ anAnnouncer announce: GtTextualCoderViewModelAstChanged new ].

	theEntries := aRecorder timeline select: [ :each | each source = 'test announcer' ].
	self assert: theEntries size equals: 1.
	self assert: theEntries first name equals: 'GtTextualCoderViewModelAstChanged'.
	^ aRecorder
]

{ #category : 'examples' }
GtTextEditorTimelineRecorderExamples >> recordsTheStylingRoundTripOfAnEditor [
	"One text set, at least one styling requested, and the styled text handed back."
	<gtExample>
	<return: #GtTextEditorTimelineRecorder>
	| aRecorder aScripter theEntries theNames |
	self ifLibEditorIsMissingDo: [ ^ GtTextEditorTimelineRecorder new ].

	aRecorder := GtTextEditorTimelineRecorder new.
	aScripter := aRecorder runDuring: [ self scripterWithRenderedEditor ].

	theEntries := aRecorder timelineFor: aScripter element.
	theNames := theEntries collect: [ :each | each name ].

	self assert: (theNames includes: 'GtTextEditorTextSetSignal').
	self assert: (theNames includes: 'GtTextEditorStylingRequestedSignal').
	self
		assert: (theEntries anySatisfy: [ :each |
				each name = 'GtTextEditorStylingRequestedSignal'
					and: [ each signal documentId isNotNil ] ]).
	^ aRecorder
]

{ #category : 'private' }
GtTextEditorTimelineRecorderExamples >> scripterWithRenderedEditor [
	"Answer a scripter holding a rendered rust editor.
	The wait step is what makes this usable in an example: setting the text only starts the
	work, and the styling and layout finish afterwards."
	<return: #BlScripter>
	| anElement aScripter |
	anElement := GtTextEditorElement new.
	anElement exact: 400 @ 200.
	anElement text: 'GtTextEditorElement >> #foo ^ 42' asRopedText.

	aScripter := BlScripter new element: anElement.
	aScripter wait
		waitRustEditorRendered: anElement pulseDuring: 5 seconds;
		play.
	^ aScripter
]

{ #category : 'examples' }
GtTextEditorTimelineRecorderExamples >> stopUnsubscribesFromTheAnnouncer [
	"Leaving the subscription in place would keep the observed announcer firing into later runs."
	<gtExample>
	<return: #GtTextEditorTimelineRecorder>
	| aRecorder anAnnouncer aCountAfterStop |
	anAnnouncer := Announcer new.
	aRecorder := GtTextEditorTimelineRecorder new.
	aRecorder observeAnnouncer: anAnnouncer labeled: 'test announcer'.
	aRecorder runDuring: [ anAnnouncer announce: GtTextualCoderViewModelAstChanged new ].
	aCountAfterStop := aRecorder timeline size.

	"Announcing after the recorder stopped must not reach it."
	anAnnouncer announce: GtTextualCoderViewModelAstChanged new.
	self assert: aRecorder timeline size equals: aCountAfterStop.
	^ aRecorder
]

{ #category : 'examples' }
GtTextEditorTimelineRecorderExamples >> timelineIsOldestFirst [
	<gtExample>
	<return: #Array>
	| aRecorder theEntries |
	aRecorder := GtTextEditorTimelineRecorder new.
	aRecorder runDuring: [
		GtTextEditorTextSetSignal new textSize: 1; emit.
		GtTextEditorTextSetSignal new textSize: 2; emit.
		GtTextEditorTextSetSignal new textSize: 3; emit ].

	theEntries := aRecorder timeline select: [ :each | each name = 'GtTextEditorTextSetSignal' ].
	self assert: (theEntries collect: [ :each | each signal textSize ]) asArray equals: #(1 2 3).
	self assert: (theEntries collect: [ :each | each sequence ]) asArray equals: #(1 2 3).
	^ theEntries asArray
]
