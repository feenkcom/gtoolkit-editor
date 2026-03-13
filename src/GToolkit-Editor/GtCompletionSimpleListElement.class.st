Class {
	#name : 'GtCompletionSimpleListElement',
	#superclass : 'BlElement',
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'listElement',
		'onCompleteBlock',
		'settings'
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
			withContainerAreaBuilders: {BlSteppedLayoutAreaBuilder dropdownBottomRight.
					BlSteppedLayoutAreaBuilder allToBottom
						alignTopRight;
						mark: BlSteppedLayoutMark bottomLeft.
					BlSteppedLayoutAreaBuilder dropdownUpRight.
					BlSteppedLayoutAreaBuilder allToUp
						alignBottomRight;
						mark: BlSteppedLayoutMark upLeft};
			stencil: [ :aBrMenuInitialContext | 
				BrMenuExplicit new
					stencil: [ aListElementOrStencil asStencil asElement removeFromParent ] ].

	false
		ifTrue: [ anAptitude relocator: BrEditorSearchTextPopoverContainerRelocator new ].

	anAnchor addAptitude: anAptitude
]

{ #category : 'initialization' }
GtCompletionSimpleListElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : 'focus requesting' }
GtCompletionSimpleListElement >> focusTarget [
	^ listElement focusTarget
]

{ #category : 'initialization' }
GtCompletionSimpleListElement >> initialize [
	super initialize.

	settings := GtCompletionSettings.
	onCompleteBlock := [ :someItems | self phlow spawnObject: someItems ].

	self initializeSettings.
	self vFitContentLimited.

	self initializeSimpleListElement.
	self addChild: listElement.

	self addAptitude: (BrLayoutResizerAptitude new common: listElement).
	self
		addAptitude: (BrGlamorousPopoverResizableAptitude new
				whenResizedDo: [ :anEvent | 
					settings completionWidth: anEvent extent x.
					self constraints vertical resizer isExact ifTrue: [
						settings completionMaxHeight: anEvent extent y.
						self constraintsDo: [ :c | c maxHeight: Float infinity ] ] ])
]

{ #category : 'initialization' }
GtCompletionSimpleListElement >> initializeSettings [
	self
		width: settings completionWidth;
		constraintsDo: [ :c | c maxHeight: settings completionMaxHeight ]
]

{ #category : 'initialization' }
GtCompletionSimpleListElement >> initializeSimpleListElement [
	listElement := BrSimpleList new
			id: GtCompletionListId;
			hMatchParent;
			vFitContentLimited;
			itemStencil: [ BrLabel new
					padding: (BlInsets left: 5 right: 5);
					hMatchParent;
					aptitude: BrGlamorousLabelAptitude + BrGlamorousListItemAptitude;
					when: BlDoubleClickEvent do: [ :anEvent | self onDoubleClickEvent: anEvent ] ];
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

{ #category : 'api - initializationF' }
GtCompletionSimpleListElement >> onComplete: aBlock [
	"Set a block that is called on completion request.
	It receives a selected item [ :aSelectedItem | ... ]."

	onCompleteBlock := aBlock
]

{ #category : 'private - event handling' }
GtCompletionSimpleListElement >> onCompleteWithSelectedItems: someSelectedItems [
	someSelectedItems ifEmpty: [ ^ self ].

	onCompleteBlock value: someSelectedItems anyOne
]

{ #category : 'private - event handling' }
GtCompletionSimpleListElement >> onDoubleClickEvent: anEvent [
	anEvent consumed: true.
	self onCompleteWithSelectedItems: listElement selectedItems
]

{ #category : 'hooks' }
GtCompletionSimpleListElement >> onStreamChanged [
	listElement selectOne: 1
]

{ #category : 'accessing' }
GtCompletionSimpleListElement >> settings [
	<return: #GtCompletionSettings>
	^ settings
]

{ #category : 'accessing' }
GtCompletionSimpleListElement >> settings: anObject [
	"Set settings object that stores user values related to the completion element.
	The object must understand:
	- completionMaxHeight, and completionMaxHeight:,
	- completionWidth, and completionWidth:.
	Note: I should be called just during the element initialization.
	Calling this method while being displayed may result in unexpected behavior."

	settings := anObject.
	self initializeSettings
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
