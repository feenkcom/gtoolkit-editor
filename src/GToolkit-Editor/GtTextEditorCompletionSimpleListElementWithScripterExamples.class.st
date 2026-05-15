Class {
	#name : 'GtTextEditorCompletionSimpleListElementWithScripterExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples - element' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> basicAnchorElement [
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
GtTextEditorCompletionSimpleListElementWithScripterExamples >> basicCompletionElement [
	<gtExample>
	| anElement |
	anElement := GtTextEditorCompletionSimpleListElement new
			settings: (GtTextEditorCompletionDummySettings new
					completionWidth: self defaultCompletionWidth;
					completionMaxHeight: self defaultCompletionMaxHeight).

	^ anElement
]

{ #category : 'support' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> defaultCompletionMaxHeight [
	^ 200
]

{ #category : 'support' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> defaultCompletionWidth [
	^ 400
]

{ #category : 'examples - element' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> emptyCompletionElement [
	<gtExample>
	| anElement aScripter |
	anElement := self basicCompletionElement.
	anElement stream: AsyncEmptyStream new.
	aScripter := BlScripter new element: anElement.

	self assert: anElement size equals: self defaultCompletionWidth @ 0.

	^ aScripter
]

{ #category : 'examples - element' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionAnchor [
	<gtExample>
	| anAnchor aList |
	anAnchor := self basicAnchorElement.
	aList := self basicCompletionElement.
	aList stream: self someClassesStream.
	anAnchor userData at: #completionList put: aList.
	GtTextEditorCompletionSimpleListElement installAptitudeOnAnchor: anAnchor stencil: aList.
	anAnchor eventDispatcher forwardShortcuts
		targetObject: aList;
		// GtTextEditorCompletionListId;
		forwardWhen: [ :anElement | anElement isAddedToSceneGraph ].
	aList onComplete: [ :aSelectedItem | anAnchor phlow spawnObject:  aSelectedItem ].

	"We allow the mouse up event so that users can play with it."
	anAnchor aptitude withMouseUpEventHandler.

	^ anAnchor
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionElement [
	<gtExample>
	| anElement aScripter anItem |
	anElement := self basicCompletionElement.
	anElement stream: self someClassesStream.
	aScripter := BlScripter new element: anElement.

	self
		assert: (aScripter element query // GtTextEditorCompletionListId / #scrollable / BrLabel) all size
				> 10.
	self assert: aScripter element width > 100.
	self assert: aScripter element height > 100.

	anItem := (anElement query // (GtTextEditorCompletionListItemId indexed: 1)) anyOne.
	self assert: anItem states isSelected.
	
	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionElement_arrowDown [
	<gtExample>
	| aScripter anItem |
	aScripter := self someClassesCompletionElement.

	aScripter do
		block: [ :aList | aList beFocusable ];
		// GtTextEditorCompletionListId;
		play.

	aScripter requestFocus
		// GtTextEditorCompletionListId;
		play.

	aScripter shortcut
		combination: BlKeyCombination arrowDown;
		// GtTextEditorCompletionListId;
		play.

	anItem := (aScripter element query // (GtTextEditorCompletionListItemId indexed: 1))
			anyOne.
	self assert: anItem states isSelected not.
	anItem := (aScripter element query // (GtTextEditorCompletionListItemId indexed: 2))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter element query // GtTextEditorCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionElement_arrowDown_arrowUp [
	<gtExample>
	| aScripter anItem |
	aScripter := self someClassesCompletionElement_arrowDown.

	aScripter shortcut
		combination: BlKeyCombination arrowUp;
		// GtTextEditorCompletionListId;
		play.

	anItem := (aScripter element query // (GtTextEditorCompletionListItemId indexed: 2))
			anyOne.
	self assert: anItem states isSelected not.
	anItem := (aScripter element query // (GtTextEditorCompletionListItemId indexed: 1))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter element query // GtTextEditorCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionElement_arrowDown_doubleClick [
	<gtExample>
	| aScripter anItem onComplete |
	aScripter := self someClassesCompletionElement_arrowDown.
	onComplete := OrderedCollection new.

	aScripter element onComplete: [ :selectedItem | onComplete add: selectedItem ].

	aScripter doubleClick
		// GtTextEditorCompletionListId;
		// (GtTextEditorCompletionListItemId indexed: 3);
		play.

	anItem := (aScripter element query // (GtTextEditorCompletionListItemId indexed: 3))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter element query // GtTextEditorCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	self assert: onComplete size equals: 1.
	self assert: onComplete anyOne equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionElement_arrowDown_tab [
	<gtExample>
	| aScripter anItem onComplete |
	aScripter := self someClassesCompletionElement_arrowDown.
	onComplete := OrderedCollection new.

	aScripter element
		onComplete: [ :selectedItem | onComplete add: selectedItem ].

	aScripter shortcut
		combination: BlKeyCombination tab;
		// GtTextEditorCompletionListId;
		play.

	anItem := (aScripter element query // (GtTextEditorCompletionListItemId indexed: 2))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter element query // GtTextEditorCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	self assert: onComplete size equals: 1.
	self assert: onComplete anyOne equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover [
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

	aSimpleList := aList childWithId: GtTextEditorCompletionListId.
	self assert: aSimpleList width equals: aList width.
	self assert: aSimpleList height equals: aList height.

	self
		assert: aList position
		equals: anAnchor bounds inSpace bottomLeft - (0@1).

	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_arrowDown [
	<gtExample>
	| anAnchor aList aScripter anItem |
	aScripter := self someClassesCompletionPopover.
	anAnchor := aScripter element.
	aList := anAnchor userData at: #completionList.

	aScripter shortcut
		combination: BlKeyCombination arrowDown;
		onPopover;
		// GtTextEditorCompletionListId;
		play.

	anItem := (aScripter root query // (GtTextEditorCompletionListItemId indexed: 1))
			anyOne.
	self assert: anItem states isSelected not.
	anItem := (aScripter root query // (GtTextEditorCompletionListItemId indexed: 2))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter root query // GtTextEditorCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_arrowDown_arrowUp [
	<gtExample>
	| anAnchor aList aScripter anItem |
	aScripter := self someClassesCompletionPopover_arrowDown.
	anAnchor := aScripter element.
	aList := anAnchor userData at: #completionList.

	aScripter shortcut
		combination: BlKeyCombination arrowUp;
		onPopover;
		// GtTextEditorCompletionListId;
		play.

	anItem := (aScripter root query // (GtTextEditorCompletionListItemId indexed: 2))
			anyOne.
	self assert: anItem states isSelected not.
	anItem := (aScripter root query // (GtTextEditorCompletionListItemId indexed: 1))
			anyOne.
	self assert: anItem states isSelected.
	self
		assert: (aScripter root query // GtTextEditorCompletionListId) anyOne selectedItems anyOne
		equals: anItem viewModel model.

	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_bottomLeftPosition [
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

	aSimpleList := aList childWithId: GtTextEditorCompletionListId.
	self assert: aSimpleList width equals: aList width.
	self assert: aSimpleList height equals: aList height.

	self
		assert: aList position
		equals: (anAnchor bounds inSpace left)
				@ (anAnchor bounds inSpace top - self defaultCompletionMaxHeight).

	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_bottomRightPosition [
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

	aSimpleList := aList childWithId: GtTextEditorCompletionListId.
	self assert: aSimpleList width equals: aList width.
	self assert: aSimpleList height equals: aList height.

	self
		assert: aList position
		equals: (800 - self defaultCompletionWidth - 20)
				@ (anAnchor bounds inSpace top - self defaultCompletionMaxHeight).

	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_escape [
	<gtExample>
	| anAnchor aList aScripter |
	aScripter := self someClassesCompletionPopover.
	anAnchor := aScripter element.
	aList := anAnchor userData at: #completionList.

	aScripter shortcut
		combination: BlKeyCombination escape;
		onPopover;
		// GtTextEditorCompletionListId;
		play.

	aScripter menuStep
		assertClosedMenuContainer;
		play.

	self assert: (aScripter root query // GtTextEditorCompletionListId) isEmpty.

	^ aScripter
]

{ #category : 'examples - scripter' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesCompletionPopover_topRightPosition [
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

	aSimpleList := aList childWithId: GtTextEditorCompletionListId.
	self assert: aSimpleList width equals: aList width.
	self assert: aSimpleList height equals: aList height.

	self
		assert: aList position
		equals: (800 - self defaultCompletionWidth - 20) @ anAnchor bounds inSpace bottom.

	^ aScripter
]

{ #category : 'support' }
GtTextEditorCompletionSimpleListElementWithScripterExamples >> someClassesStream [
	<gtExample>
	^ (self class package classes sorted: [ :a :b | a name < b name ])
		asAsyncStream
		map: [ :aClass | GtCompletionAction new label: aClass name ]
]
