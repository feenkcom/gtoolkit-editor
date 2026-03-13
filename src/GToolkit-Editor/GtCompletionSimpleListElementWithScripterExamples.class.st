Class {
	#name : 'GtCompletionSimpleListElementWithScripterExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples - element' }
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

{ #category : 'examples - element' }
GtCompletionSimpleListElementWithScripterExamples >> basicCompletionElement [
	<gtExample>
	| anElement |
	anElement := GtCompletionSimpleListElement new
			settings: (GtCompletionDummySettings new
					completionWidth: self defaultCompletionWidth;
					completionMaxHeight: self defaultCompletionMaxHeight).

	self assert: anElement constraints horizontal resizer isExact.
	self
		assert: anElement constraints horizontal resizer size
		equals: self defaultCompletionWidth.

	self
		assert: anElement constraints maxHeight
		equals: self defaultCompletionMaxHeight.

	^ anElement
]

{ #category : 'support' }
GtCompletionSimpleListElementWithScripterExamples >> defaultCompletionMaxHeight [
	^ 200
]

{ #category : 'support' }
GtCompletionSimpleListElementWithScripterExamples >> defaultCompletionWidth [
	^ 400
]

{ #category : 'examples - element' }
GtCompletionSimpleListElementWithScripterExamples >> emptyCompletionElement [
	<gtExample>
	| anElement aScripter |
	anElement := self basicCompletionElement.
	anElement stream: AsyncEmptyStream new.
	aScripter := BlScripter new element: anElement.

	self assert: anElement size equals: self defaultCompletionWidth @ 0.

	^ aScripter
]

{ #category : 'examples - element' }
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
	aList onComplete: [ :aSelectedItem | anAnchor phlow spawnObject:  aSelectedItem ].

	"We allow the mouse up event so that users can play with it."
	anAnchor aptitude withMouseUpEventHandler.

	^ anAnchor
]

{ #category : 'examples - scripter' }
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

{ #category : 'examples - scripter' }
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

{ #category : 'examples - scripter' }
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

{ #category : 'examples - scripter' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionElement_arrowDown_doubleClick [
	<gtExample>
	| aScripter anItem onComplete |
	aScripter := self someClassesCompletionElement_arrowDown.
	onComplete := OrderedCollection new.

	aScripter element onComplete: [ :selectedItem | onComplete add: selectedItem ].

	aScripter doubleClick
		// GtCompletionListId;
		// (GtCompletionListItemId indexed: 3);
		play.

	anItem := (aScripter element query // (GtCompletionListItemId indexed: 3))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter element query // GtCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	self assert: onComplete size equals: 1.
	self assert: onComplete anyOne equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples - scripter' }
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

{ #category : 'examples - scripter' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover [
	<gtExample>
	| anAnchor aList aScripter aSimpleList |
	anAnchor := self someClassesCompletionAnchor.
	aList := anAnchor userData at: #completionList.
	aScripter := BlScripter new element: anAnchor.

	aScripter do
		block: [ :anElement | anElement dispatchEvent: BrDropdownShowWish new ];
		play.

	self assert: aList isAddedToSceneGraph.
	self assert: (aList query // #scrollable / BrLabel) all size > 10.
	self assert: aList height equals: self defaultCompletionMaxHeight.
	self assert: aList width equals: self defaultCompletionWidth.

	aSimpleList := aList childWithId: GtCompletionListId.
	self assert: aSimpleList width equals: aList width.
	self assert: aSimpleList height equals: aList height.

	self
		assert: aList position
		equals: anAnchor bounds inSpace bottomLeft - (0@1).

	^ aScripter
]

{ #category : 'examples - scripter' }
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

{ #category : 'examples - scripter' }
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

{ #category : 'examples - scripter' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_bottomLeftPosition [
	<gtExample>
	| anAnchor aList aScripter aSimpleList |
	anAnchor := self someClassesCompletionAnchor.
	anAnchor relocate: 100 @ 550.
	aList := anAnchor userData at: #completionList.
	aScripter := BlScripter new element: anAnchor.

	aScripter do
		block: [ :anElement | anElement dispatchEvent: BrDropdownShowWish new ];
		play.

	self assert: aList isAddedToSceneGraph.
	self assert: (aList query // #scrollable / BrLabel) all size > 10.
	self assert: aList height equals: self defaultCompletionMaxHeight.
	self assert: aList width equals: self defaultCompletionWidth.

	aSimpleList := aList childWithId: GtCompletionListId.
	self assert: aSimpleList width equals: aList width.
	self assert: aSimpleList height equals: aList height.

	self
		assert: aList position
		equals: (anAnchor bounds inSpace left)
				@ (anAnchor bounds inSpace top - self defaultCompletionMaxHeight).

	^ aScripter
]

{ #category : 'examples - scripter' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_bottomRightPosition [
	<gtExample>
	| anAnchor aList aScripter aSimpleList |
	anAnchor := self someClassesCompletionAnchor.
	anAnchor relocate: (800 - (self defaultCompletionWidth / 2)) @ 550.
	aList := anAnchor userData at: #completionList.
	aScripter := BlScripter new element: anAnchor.

	aScripter do
		block: [ :anElement | anElement dispatchEvent: BrDropdownShowWish new ];
		play.

	self assert: aList isAddedToSceneGraph.
	self assert: (aList query // #scrollable / BrLabel) all size > 10.
	self assert: aList height equals: self defaultCompletionMaxHeight.
	self assert: aList width equals: self defaultCompletionWidth.

	aSimpleList := aList childWithId: GtCompletionListId.
	self assert: aSimpleList width equals: aList width.
	self assert: aSimpleList height equals: aList height.

	self
		assert: aList position
		equals: (800 - self defaultCompletionWidth - 20)
				@ (anAnchor bounds inSpace top - self defaultCompletionMaxHeight).

	^ aScripter
]

{ #category : 'examples - scripter' }
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

{ #category : 'examples - scripter' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_topRightPosition [
	<gtExample>
	| anAnchor aList aScripter aSimpleList |
	anAnchor := self someClassesCompletionAnchor.
	anAnchor relocate: (800 - (self defaultCompletionWidth / 2)) @ 150.
	aList := anAnchor userData at: #completionList.
	aScripter := BlScripter new element: anAnchor.

	aScripter do
		block: [ :anElement | anElement dispatchEvent: BrDropdownShowWish new ];
		play.

	self assert: aList isAddedToSceneGraph.
	self assert: (aList query // #scrollable / BrLabel) all size > 10.
	self assert: aList height equals: self defaultCompletionMaxHeight.
	self assert: aList width equals: self defaultCompletionWidth.

	aSimpleList := aList childWithId: GtCompletionListId.
	self assert: aSimpleList width equals: aList width.
	self assert: aSimpleList height equals: aList height.

	self
		assert: aList position
		equals: (800 - self defaultCompletionWidth - 20) @ anAnchor bounds inSpace bottom.

	^ aScripter
]

{ #category : 'support' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesStream [
	<gtExample>
	^ (self class package classes sorted: [ :a :b | a name < b name ])
		asAsyncStream
		map: [ :aClass | GtCompletionAction new label: aClass name ]
]
