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
GtTextEditorTimelineRecorderExamples >> defaultSignalClassesCoverTheEditorSignalTree [
	"One entry covers the whole editor signal tree, so a signal class added later is recorded
	without the defaults having to be touched. That tree also holds the layout, measure and
	request layout signals, which fire continuously for every live editor and each capture a full
	call stack, so these defaults are only affordable because recording is off until it is asked
	for. See #recordingIsOffUntilTheSwitchIsOn."
	<gtExample>
	<return: #Collection>
	| theClasses |
	theClasses := GtTextEditorTimelineRecorder new signalClasses.
	self assert: theClasses isNotEmpty.
	self assert: (theClasses includes: GtTextEditorSignal).
	{GtTextEditorStylingRequestedSignal.
		GtTextEditorStyledTextAppliedSignal.
		GtTextEditorStyledTextRejectedSignal.
		GtTextEditorAnnouncementSignal}
		do: [ :eachClass | self assert: (eachClass includesBehavior: GtTextEditorSignal) ].
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
GtTextEditorTimelineRecorderExamples >> observingOneAnnouncementClassIgnoresTheOthers [
	"An observation is narrowed to one announcement class when a generic subscription records too much.
	Everything else the same announcer sends then has to stay off the timeline.

	This is the one case that needs two distinct classes, so it uses
	${class:GtTextEditorExampleAnnouncement}$ for the narrowed one and `Announcement` for the other.
	`Announcement` is not a kind of it, which is what makes it the right counter example."
	<gtExample>
	<return: #GtTextEditorTimelineRecorder>
	| aRecorder anAnnouncer theEntries |
	anAnnouncer := Announcer new.
	aRecorder := GtTextEditorTimelineRecorder new.
	aRecorder isEnabled: true.
	aRecorder
		observeAnnouncer: anAnnouncer
		announcement: GtTextEditorExampleAnnouncement
		labeled: 'test announcer'.

	aRecorder runDuring: [ anAnnouncer announce: Announcement new.
		anAnnouncer announce: GtTextEditorExampleAnnouncement new ].

	theEntries := aRecorder timeline select: [ :each | each source = 'test announcer' ].
	self assert: theEntries size equals: 1.
	self assert: theEntries first name equals: 'GtTextEditorExampleAnnouncement'.
	^ aRecorder
]

{ #category : 'examples' }
GtTextEditorTimelineRecorderExamples >> recordingIsOffUntilTheSwitchIsOn [
	"Recording the editor signal tree is expensive enough that it has to be asked for, so a
	recorder that is not enabled runs its block and records nothing. That is what keeps a recorder
	forgotten in a test from slowing the image down."
	<gtExample>
	<return: #Collection>
	| aDisabledRecorder anEnabledRecorder aBlockRan |
	aDisabledRecorder := GtTextEditorTimelineRecorder new.
	aDisabledRecorder isEnabled: false.
	anEnabledRecorder := GtTextEditorTimelineRecorder new.
	anEnabledRecorder isEnabled: true.
	aBlockRan := false.

	aDisabledRecorder
		runDuring: [ aBlockRan := true.
			GtTextEditorStylingRequestedSignal new emit ].
	anEnabledRecorder runDuring: [ GtTextEditorStylingRequestedSignal new emit ].

	"The block runs either way, only the recording is skipped."
	self assert: aDisabledRecorder isEnabled not.
	self assert: aBlockRan.
	self assert: aDisabledRecorder timeline isEmpty.

	"The same emit lands on the timeline once recording is enabled, so that is what gates it."
	self assert: anEnabledRecorder isEnabled.
	self assert: anEnabledRecorder timeline isNotEmpty.
	^ anEnabledRecorder timeline
]

{ #category : 'examples' }
GtTextEditorTimelineRecorderExamples >> recordsAnnouncementsOfAGivenAnnouncer [
	"The recorder holds no reference to any announcement class, so it records an announcer it knows
	nothing about. `Announcement` itself is the strongest way to say that: there is nothing more generic
	for it to have been taught about in advance.

	That genericity is not a convenience, it is what lets the recorder observe a coder view model without
	`GToolkit-Editor` depending on the packages that define coder announcements. An example announcing a
	coder announcement would create exactly that dependency."
	<gtExample>
	<return: #GtTextEditorTimelineRecorder>
	| aRecorder anAnnouncer theEntries |
	anAnnouncer := Announcer new.
	aRecorder := GtTextEditorTimelineRecorder new.
	aRecorder isEnabled: true.
	aRecorder observeAnnouncer: anAnnouncer labeled: 'test announcer'.
	aRecorder runDuring: [ anAnnouncer announce: Announcement new ].

	theEntries := aRecorder timeline select: [ :each | each source = 'test announcer' ].
	self assert: theEntries size equals: 1.
	self assert: theEntries first name equals: 'Announcement'.
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
	aRecorder isEnabled: true.
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
	aRecorder isEnabled: true.
	aRecorder observeAnnouncer: anAnnouncer labeled: 'test announcer'.
	aRecorder runDuring: [ anAnnouncer announce: Announcement new ].
	aCountAfterStop := aRecorder timeline size.

	"The announcement has to have been recorded, or there is nothing here to unsubscribe from."
	self assert: aCountAfterStop > 0.

	"Announcing after the recorder stopped must not reach it."
	anAnnouncer announce: Announcement new.
	self assert: aRecorder timeline size equals: aCountAfterStop.
	^ aRecorder
]

{ #category : 'examples' }
GtTextEditorTimelineRecorderExamples >> timelineIsOldestFirst [
	<gtExample>
	<return: #Array>
	| aRecorder theEntries |
	aRecorder := GtTextEditorTimelineRecorder new.
	aRecorder isEnabled: true.
	aRecorder runDuring: [ 
		GtTextEditorTextSetSignal new textSize: 1; emit.
		GtTextEditorTextSetSignal new textSize: 2; emit.
		GtTextEditorTextSetSignal new textSize: 3; emit ].

	theEntries := aRecorder timeline select: [ :each | each name = 'GtTextEditorTextSetSignal' ].
	self assert: (theEntries collect: [ :each | each signal textSize ]) asArray equals: #(1 2 3).
	self assert: (theEntries collect: [ :each | each sequence ]) asArray equals: #(1 2 3).
	^ theEntries asArray
]
