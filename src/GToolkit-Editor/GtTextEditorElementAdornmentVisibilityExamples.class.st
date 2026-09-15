"
Regression examples for the bug where a collapsed-then-re-expanded toggle adornment stayed clickable at its old, now-stale bounds. A collapsed cached adornment child must become BlVisibility gone (not just be dropped from tracking), stop receiving clicks, and become visible again on re-expand without recreating the cached child element.
"
Class {
	#name : 'GtTextEditorElementAdornmentVisibilityExamples',
	#superclass : 'Object',
	#instVars : [
		'expanderAttribute'
	],
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples' }
GtTextEditorElementAdornmentVisibilityExamples >> collapsedAdornmentBecomesGoneAndStopsReceivingClicksThenReExpandsWithoutRecreatingTheChild [
	"Regression test for the bug this feature exists to fix: expanding, collapsing,
	then re-expanding a cached toggle adornment must remove/re-add the SAME cached
	child element (not just toggle its visibility) instead of leaving a stale,
	still-clickable child behind after collapse."
	<gtExample>
	<return: #GtTextEditorElement>
	| anElement contentBox oldPosition |
	anElement := self elementWithCollapsedToggleAdornment.

	"Expand: toggle on. The content box gets created lazily once the rust
	side asks for/derives its measurement, so wait for it to actually be
	sized and positioned (not just added as a child) before clicking it.
	Clicks are simulated `on: anElement` (not `on: contentBox`): once
	contentBox is detached from anElement it becomes its own topMostParent,
	so simulating `on: contentBox` would wrap it alone in an isolated
	temporary space and trivially 'hit' it regardless of real reachability —
	only `on: anElement` (which stays attached throughout) does a real hit
	test against the actual UI tree."
	self expanderAttribute toggleExpandedOrCollapsedIn: anElement.
	self
		waitUntil: [ (self contentBoxIn: anElement) notNil
				and: [ (self contentBoxIn: anElement) extent > (0 @ 0) ] ]
		on: anElement.
	contentBox := self contentBoxIn: anElement.

	oldPosition := contentBox bounds inSpace center.
	self simulateClickAt: oldPosition on: anElement.
	self assert: (contentBox userData at: #clickCount) equals: 1.

	"Collapse: toggle off. The cached child element must be removed from the
	scene graph (not just hidden), and must no longer receive clicks."
	self expanderAttribute toggleExpandedOrCollapsedIn: anElement.
	self waitUntil: [ (self contentBoxIn: anElement) isNil ] on: anElement.

	self simulateClickAt: oldPosition on: anElement.
	self
		assert: (contentBox userData at: #clickCount) = 1
		description: [ 'a click at the old bounds must no longer reach the removed (collapsed) adornment' ].

	"Re-expand: toggle on again. The SAME cached child object must be
	re-added, not recreated."
	self expanderAttribute toggleExpandedOrCollapsedIn: anElement.
	self waitUntil: [ (self contentBoxIn: anElement) notNil ] on: anElement.
	self
		assert: (self contentBoxIn: anElement) == contentBox
		description: [ 'the same cached child must be reused on re-expand, not recreated' ].

	self simulateClickAt: oldPosition on: anElement.
	self assert: (contentBox userData at: #clickCount) equals: 2.

	^ anElement
]

{ #category : 'support' }
GtTextEditorElementAdornmentVisibilityExamples >> contentBoxIn: anElement [
	^ anElement children
		detect: [ :eachChild | eachChild userData at: #isAdornmentContentBox ifAbsent: [ false ] ]
		ifNone: [ nil ]
]

{ #category : 'examples' }
GtTextEditorElementAdornmentVisibilityExamples >> elementWithCollapsedToggleAdornment [
	"A GtTextEditorElement with a triangle expander (collapsed by default) whose
	expanded content is a small clickable box, mirroring how a coder's
	referenceElement:-style inline expander is built. Captures the expander
	attribute (before the text is handed to the editor) into the expanderAttribute
	ivar, the same way BrTextStreamExamples>>#elaborateTextAndAdornment finds it."
	<gtExample>
	<return: #GtTextEditorElement>
	| stream anElement |
	stream := BlTextStream new.
	stream next putAll: 'before'.
	stream next
		expanded: false
			adornment: [ :aPiece :anEditor |
				| contentBox |
				contentBox := BlElement new.
				contentBox constraintsDo: [ :c | c horizontal exact: 40. c vertical exact: 40 ].
				contentBox background: Color blue.
				contentBox userData at: #isAdornmentContentBox put: true.
				contentBox userData at: #clickCount put: 0.
				contentBox
					when: BlClickEvent
					do: [ :anEvent | contentBox userData at: #clickCount put: (contentBox userData at: #clickCount) + 1 ].
				contentBox ];
		putAll: ' x'.

	expanderAttribute := (stream contents attributesAt: stream contents size)
		detect: [ :each | each class = BrGlamorousTriangleExpanderTextAttributeV2 ].

	anElement := GtTextEditorElement new.
	anElement exact: 200 @ 200.
	anElement text: stream contents.
	^ anElement
]

{ #category : 'examples' }
GtTextEditorElementAdornmentVisibilityExamples >> elementWithCollapsedToggleAdornment2 [
	"A GtTextEditorElement with a triangle expander (collapsed by default) whose
	expanded content is a small clickable box, mirroring how a coder's
	referenceElement:-style inline expander is built. Captures the expander
	attribute (before the text is handed to the editor) into the expanderAttribute
	ivar, the same way BrTextStreamExamples>>#elaborateTextAndAdornment finds it."

	<gtExample>
	<return: #GtTextEditorElement>
	| anElement aText |
	aText := 'Text with expander attribute.' asRopedText
			glamorousRegularFontAndSize.
	(aText from: 18 to: 18)
		expanded: false
		adornment: [ :aTBrTextEditorTextualPiece :anEditorElement | 
			BlElement new
				id: #expanded;
				size: 100 @ 200;
				background: (Color blue alpha: 0.5) ]
		id: #expander.

	anElement := GtTextEditorElement new.
	anElement matchParent.
	anElement text: aText.
	^ anElement
]

{ #category : 'examples' }
GtTextEditorElementAdornmentVisibilityExamples >> elementWithCollapsedToggleAdornment2_expand [
	"A GtTextEditorElement with a triangle expander (collapsed by default) whose
	expanded content is a small clickable box, mirroring how a coder's
	referenceElement:-style inline expander is built. Captures the expander
	attribute (before the text is handed to the editor) into the expanderAttribute
	ivar, the same way BrTextStreamExamples>>#elaborateTextAndAdornment finds it."

	<gtExample>
	<noTest>
	| aScripter aSemaphore anElement |
	anElement := self elementWithCollapsedToggleAdornment2.
	aScripter := BlScripter new element: anElement.

	"aSemaphore := Semaphore new.
	anElement privateRequestEditorAction: [ :aMessage | aSemaphore signal ].

	aScripter wait
		forSemaphore: aSemaphore pulseDuring: 5 seconds;
		play.

	self assert: aSemaphore isSignaled.

	aScripter wait
		forCondition: [ :aSpace | anElement childrenCount = 15 ]
			pulseDuring: 5 seconds;
		play."

	aScripter click
		// #expander;
		play.

	^ aScripter
]

{ #category : 'support' }
GtTextEditorElementAdornmentVisibilityExamples >> expanderAttribute [
	^ expanderAttribute
]

{ #category : 'support' }
GtTextEditorElementAdornmentVisibilityExamples >> simulateClickAt: aPosition on: anElement [
	"Like BlSpace class>>#simulateClickOn:, but at a fixed position rather than
	anElement's current bounds center - needed to click at the OLD position of
	an element that may now be BlVisibility gone (and so has no usable bounds)."
	BlSpace
		simulateEvents: {
			BlMouseDownEvent primary position: aPosition.
			BlMouseUpEvent primary position: aPosition }
		on: anElement
]

{ #category : 'support' }
GtTextEditorElementAdornmentVisibilityExamples >> waitUntil: aBlock on: anElement [
	"The rust-backed editor delivers adornment measurement/visibility messages
	asynchronously through a polled FFI queue. Repeatedly force a layout pass and
	drain the queue, giving the native side a moment to catch up, before giving up."
	| deadline |
	deadline := DateAndTime now + 2 seconds.
	[
		anElement forceLayout.
		anElement pollEditorMessages.
		aBlock value or: [ DateAndTime now > deadline ]
	] whileFalse: [ (Delay forMilliseconds: 20) wait ]
]
