Class {
	#name : 'GtCompletionSimpleListElement',
	#superclass : 'BlElement',
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'listElement',
		'onCompleteBlock'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'factory' }
GtCompletionSimpleListElement class >> installAptitudeOnAnchor: anAnchor stencil: aListElementOrStencil [
	| anAptitude |
	anAptitude := BrGlamorousWithExplicitDropdownAptitude new
			withoutGainFocusOnShow;
			withoutHandle;
			withoutMouseEventHandler;
			withContainerAreaBuilders: {
					BlSteppedLayoutAreaBuilder dropdownBottomRight.
					BlSteppedLayoutAreaBuilder allToBottom alignBottomRight.
					BlSteppedLayoutAreaBuilder dropdownUpRight.
					BlSteppedLayoutAreaBuilder allToUp alignBottomRight };
			stencil: [ :aBrMenuInitialContext | 
				BrMenuExplicit new
					stencil: [ aListElementOrStencil asStencil asElement removeFromParent ] ].

	false
		ifTrue: [ anAptitude relocator: BrEditorSearchTextPopoverContainerRelocator new ].

	anAnchor addAptitude: anAptitude
]

{ #category : 'initialization' }
GtCompletionSimpleListElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : 'focus requesting' }
GtCompletionSimpleListElement >> focusTarget [
	^ listElement focusTarget
]

{ #category : 'initialization' }
GtCompletionSimpleListElement >> initialize [
	super initialize.
	
	onCompleteBlock := [ :someItems | self phlow spawnObject: someItems ].
	
	self
		hFitContentLimited;
		vFitContentLimited.

	self initializeSimpleListElement.
	self addAptitude: (BrLayoutResizerAptitude new common: listElement).
	
	self addChild: listElement
]

{ #category : 'initialization' }
GtCompletionSimpleListElement >> initializeSimpleListElement [
	listElement := BrSimpleList new
			id: GtCompletionListId;
			hFitContentLimited;
			vFitContentLimited;
			itemStencil: [ BrLabel new
					padding: (BlInsets left: 5 right: 5);
					hMatchParent;
					aptitude: BrGlamorousLabelAptitude + BrGlamorousListItemAptitude ];
			itemDataBinder: [ :eachLabel :eachItem :eachIndex | 
				eachLabel text: eachItem label.
				eachLabel id: (GtCompletionListItemId indexed: eachIndex).
				eachLabel viewModel model: eachItem.
				eachLabel ];
			addShortcut: (BlShortcutWithAction new
					name: 'Complete with selected item';
					combination: BlKeyCombination tab;
					action: [ :aShortcutEvent :aShortcut | self onCompleteWithSelectedItems: aShortcutEvent currentTarget selectedItems ]);
			addShortcut: (BlShortcutWithAction new
					name: 'Complete with selected item';
					combination: BlKeyCombination enter;
					action: [ :aShortcutEvent :aShortcut | 
						GtCompletionController completeOnReturn
							ifTrue: [ self onCompleteWithSelectedItems: aShortcutEvent currentTarget selectedItems ]
							ifFalse: [ aShortcutEvent beNotConsumed ] ])
]

{ #category : 'as yet unclassified' }
GtCompletionSimpleListElement >> onComplete: aBlock [
	"Set a block that is called on completion request.
	It receives a selected item [ :aSelectedItem | ... ]."

	onCompleteBlock := aBlock
]

{ #category : 'initialization' }
GtCompletionSimpleListElement >> onCompleteWithSelectedItems: someSelectedItems [
	someSelectedItems ifEmpty: [ ^ self ].

	onCompleteBlock value: someSelectedItems anyOne
]

{ #category : 'hooks' }
GtCompletionSimpleListElement >> onStreamChanged [
	listElement selectOne: 1
]

{ #category : 'api - accessing' }
GtCompletionSimpleListElement >> stream: aStream [
	"Set a stream of GtCompletionAction instances 
	(or any other instances that respond to #label calls)."

	listElement stream: aStream.
	self onStreamChanged
]

{ #category : 'api - accessing' }
GtCompletionSimpleListElement >> stream: anAsyncStream executionConfiguration: anAsyncFutureExecutionConfiguration [
	listElement
		stream: anAsyncStream
		executionConfiguration: anAsyncFutureExecutionConfiguration.
	self onStreamChanged
]
