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
	anElement := BrFrame new exact: 5 @ 10.

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
	| anElement aScripter |
	anElement := self basicCompletionElement.
	anElement stream: self someClassesStream.
	aScripter := BlScripter new element: anElement.

	self
		assert: (aScripter element query // GtCompletionListId / #scrollable / BrLabel) all size
				> 10.
	self assert: aScripter element width > 100.
	self assert: aScripter element height > 100.

	^ aScripter
]

{ #category : 'examples' }
GtCompletionSimpleListElementWithScripterExamples >> someClassesStream [
	<gtExample>
	^ (self class package classes sorted: [ :a :b | a name < b name ])
		asAsyncStream
		map: [ :aClass | GtCompletionAction new label: aClass name ]
]
