Class {
	#name : 'GtCompletionSimpleListElementWithScripterExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> basicAnchorElement [
	<gtExample>
	| anElement |
	anElement := BrFrame new
			id: #anchor;
			beFocusable;
			requestFocus;
			relocate: 100 @ 150;
			when: BlClickEvent
				do: [ :anEvent | 
					anEvent consumed: true.
					anEvent currentTarget requestFocus ];
			exact: 15 @ 15;
			background: Color red;
			addEventHandler: BlPullHandler new disallowOutOfBounds.

	^ anElement
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> basicCompletionElement [
	<gtExample>
	| anElement |
	anElement := GtCompletionSimpleListElement new.

	^ anElement
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> emptyCompletionElement [
	<gtExample>
	| anElement aScripter |
	anElement := self basicCompletionElement.
	anElement stream: AsyncEmptyStream new.
	aScripter := BlScripter new element: anElement.
	
	self assert: anElement size equals: 0@0.

	^ aScripter
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionAnchor [
	<gtExample>
	| anAnchor aList |
	anAnchor := self basicAnchorElement.
	aList := self basicCompletionElement.
	aList stream: self someClassesStream.
	anAnchor userData at: #completionList put: aList.
	GtCompletionSimpleListElement installAptitudeOnAnchor: anAnchor stencil: aList.
	anAnchor eventDispatcher forwardShortcuts
		targetObject: aList;
		// GtCompletionListId;
		forwardWhen: [ :anElement | anElement isAddedToSceneGraph ].

	"We allow the mouse up event so that users can play with it."
	anAnchor aptitude withMouseUpEventHandler.

	^ anAnchor
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionElement [
	<gtExample>
	| anElement aScripter anItem |
	anElement := self basicCompletionElement.
	anElement stream: self someClassesStream.
	aScripter := BlScripter new element: anElement.

	self
		assert: (aScripter element query // GtCompletionListId / #scrollable / BrLabel) all size
				> 10.
	self assert: aScripter element width > 100.
	self assert: aScripter element height > 100.

	anItem := (anElement query // (GtCompletionListItemId indexed: 1)) anyOne.
	self assert: anItem states isSelected.
	
	^ aScripter
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionElement_arrowDown [
	<gtExample>
	| aScripter anItem |
	aScripter := self someClassesCompletionElement.

	aScripter do
		block: [ :aList | aList beFocusable ];
		// GtCompletionListId;
		play.

	aScripter requestFocus
		// GtCompletionListId;
		play.

	aScripter shortcut
		combination: BlKeyCombination arrowDown;
		// GtCompletionListId;
		play.

	anItem := (aScripter element query // (GtCompletionListItemId indexed: 1))
			anyOne.
	self assert: anItem states isSelected not.
	anItem := (aScripter element query // (GtCompletionListItemId indexed: 2))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter element query // GtCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionElement_arrowDown_arrowUp [
	<gtExample>
	| aScripter anItem |
	aScripter := self someClassesCompletionElement_arrowDown.

	aScripter shortcut
		combination: BlKeyCombination arrowUp;
		// GtCompletionListId;
		play.

	anItem := (aScripter element query // (GtCompletionListItemId indexed: 2))
			anyOne.
	self assert: anItem states isSelected not.
	anItem := (aScripter element query // (GtCompletionListItemId indexed: 1))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter element query // GtCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionElement_arrowDown_tab [
	<gtExample>
	| aScripter anItem onComplete |
	aScripter := self someClassesCompletionElement_arrowDown.
	onComplete := OrderedCollection new.

	aScripter element
		onComplete: [ :selectedItem | onComplete add: selectedItem ].

	aScripter shortcut
		combination: BlKeyCombination tab;
		// GtCompletionListId;
		play.

	anItem := (aScripter element query // (GtCompletionListItemId indexed: 2))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter element query // GtCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	self assert: onComplete size equals: 1.
	self assert: onComplete anyOne equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover [
	<gtExample>
	| anAnchor aList aScripter |
	anAnchor := self someClassesCompletionAnchor.
	aList := anAnchor userData at: #completionList.
	aScripter := BlScripter new element: anAnchor.

	aScripter do
		block: [ :anElement | anElement dispatchEvent: BrDropdownShowWish new ];
		play.

	self assert: aList isAddedToSceneGraph.
	self assert: (aList query // #scrollable / BrLabel) all size > 10.
	self assert: aList width > 100.
	self assert: aList height > 100.

	^ aScripter
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_arrowDown [
	<gtExample>
	| anAnchor aList aScripter anItem |
	aScripter := self someClassesCompletionPopover.
	anAnchor := aScripter element.
	aList := anAnchor userData at: #completionList.

	aScripter shortcut
		combination: BlKeyCombination arrowDown;
		onPopover;
		// GtCompletionListId;
		play.

	anItem := (aScripter root query // (GtCompletionListItemId indexed: 1))
			anyOne.
	self assert: anItem states isSelected not.
	anItem := (aScripter root query // (GtCompletionListItemId indexed: 2))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter root query // GtCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_arrowDown_arrowUp [
	<gtExample>
	| anAnchor aList aScripter anItem |
	aScripter := self someClassesCompletionPopover_arrowDown.
	anAnchor := aScripter element.
	aList := anAnchor userData at: #completionList.

	aScripter shortcut
		combination: BlKeyCombination arrowUp;
		onPopover;
		// GtCompletionListId;
		play.

	anItem := (aScripter root query // (GtCompletionListItemId indexed: 2))
			anyOne.
	self assert: anItem states isSelected not.
	anItem := (aScripter root query // (GtCompletionListItemId indexed: 1))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter root query // GtCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_escape [
	<gtExample>
	| anAnchor aList aScripter |
	aScripter := self someClassesCompletionPopover.
	anAnchor := aScripter element.
	aList := anAnchor userData at: #completionList.

	aScripter shortcut
		combination: BlKeyCombination escape;
		onPopover;
		// GtCompletionListId;
		play.

	aScripter menuStep
		assertClosedMenuContainer;
		play.

	self assert: (aScripter root query // GtCompletionListId) isEmpty.

	^ aScripter
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesStream [
	<gtExample>
	^ (self class package classes sorted: [ :a :b | a name < b name ])
		asAsyncStream
		map: [ :aClass | GtCompletionAction new label: aClass name ]
]
