Class {
	#name : 'GtTextEditorCompletionSimpleListElement',
	#superclass : 'BlElement',
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'listElement',
		'onCompleteBlock',
		'settings'
	],
	#category : 'GToolkit-Editor-Completion',
	#package : 'GToolkit-Editor',
	#tag : 'Completion'
}

{ #category : 'factory' }
GtTextEditorCompletionSimpleListElement class >> installAptitudeOnAnchor: anAnchor stencil: aListElementOrStencil [
	| anAptitude |
	anAptitude := BrGlamorousWithExplicitDropdownAptitude new
			withoutGainFocusOnShow;
			withoutHandle;
			withoutMouseEventHandler;
			withContainerAreaBuilders: {
				BlSteppedLayoutAreaBuilder dropdownBottomRight.
				
				BlSteppedLayoutAreaBuilder allToBottom
					alignTopRight;
					mark: BlSteppedLayoutMark bottomLeft.
		
				BlSteppedLayoutAreaBuilder dropdownUpRight.
				BlSteppedLayoutAreaBuilder allToUp
					alignBottomRight;
					mark: BlSteppedLayoutMark upLeft
			};
			stencil: [ :aBrMenuInitialContext | 
				BrMenuExplicit new
					stencil: [ aListElementOrStencil asStencil asElement removeFromParent ] ].

	false
		ifTrue: [ anAptitude relocator: BrEditorSearchTextPopoverContainerRelocator new ].

	anAnchor addAptitude: anAptitude
]

{ #category : 'focus requesting' }
GtTextEditorCompletionSimpleListElement >> focusTarget [
	^ listElement focusTarget
]

{ #category : 'initialization' }
GtTextEditorCompletionSimpleListElement >> initialize [
	super initialize.

	settings := GtTextEditorCompletionSettings.
	onCompleteBlock := [ :someItems | self phlow spawnObject: someItems ].

	self
		layout: BlFrameLayout new;
		vFitContentLimited.

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
GtTextEditorCompletionSimpleListElement >> initializeSettingsInSpace: aSpace [
	| width maxHeight |

	width := settings completionWidthOrNil
		ifNil: [ aSpace width / 3.0 ].

	maxHeight := settings completionMaxHeightOrNil
		ifNil: [ aSpace height / 3.0 ].

	self
		width: width;
		constraintsDo: [ :c | c maxHeight: maxHeight ]
]

{ #category : 'initialization' }
GtTextEditorCompletionSimpleListElement >> initializeSimpleListElement [
	listElement := BrSimpleList new
			id: GtTextEditorCompletionListId;
			hMatchParent;
			vFitContentLimited;
			itemStencil: [ BrLabel new
					padding: (BlInsets left: 5 right: 5);
					hMatchParent;
					aptitude: BrGlamorousLabelAptitude + BrGlamorousListItemAptitude;
					when: BlDoubleClickEvent do: [ :anEvent | self onDoubleClickEvent: anEvent ] ];
			itemDataBinder: [ :eachLabel :eachItem :eachIndex | 
				eachLabel text: eachItem label.
				eachLabel id: (GtTextEditorCompletionListItemId indexed: eachIndex).
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
GtTextEditorCompletionSimpleListElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	
	self spaceDo: [ :aSpace | self initializeSettingsInSpace: aSpace ]
]

{ #category : 'api - initializationF' }
GtTextEditorCompletionSimpleListElement >> onComplete: aBlock [
	"Set a block that is called on completion request.
	It receives a selected item [ :aSelectedItem | ... ]."

	onCompleteBlock := aBlock
]

{ #category : 'private - event handling' }
GtTextEditorCompletionSimpleListElement >> onCompleteWithSelectedItems: someSelectedItems [
	someSelectedItems ifEmpty: [ ^ self ].

	onCompleteBlock value: someSelectedItems anyOne
]

{ #category : 'private - event handling' }
GtTextEditorCompletionSimpleListElement >> onDoubleClickEvent: anEvent [
	anEvent consumed: true.
	self onCompleteWithSelectedItems: listElement selectedItems
]

{ #category : 'hooks' }
GtTextEditorCompletionSimpleListElement >> onStreamChanged [
	listElement selectOne: 1
]

{ #category : 'accessing' }
GtTextEditorCompletionSimpleListElement >> settings [
	<return: #GtTextEditorCompletionSettings>
	^ settings
]

{ #category : 'accessing' }
GtTextEditorCompletionSimpleListElement >> settings: anObject [
	"Set settings object that stores user values related to the completion element.
	The object must understand:
	- completionMaxHeightOrNil, and completionMaxHeight:,
	- completionWidthOrNil, and completionWidth:.
	Note: I should be called just during the element initialization.
	Calling this method while being displayed may result in unexpected behavior."

	settings := anObject.
	self spaceDo: [ :aSpace | self initializeSettingsInSpace: aSpace ]
]

{ #category : 'api - accessing' }
GtTextEditorCompletionSimpleListElement >> stream: aStream [
	"Set a stream of GtCompletionAction instances 
	(or any other instances that respond to #label calls)."

	listElement stream: aStream.
	self onStreamChanged
]

{ #category : 'api - accessing' }
GtTextEditorCompletionSimpleListElement >> stream: anAsyncStream executionConfiguration: anAsyncFutureExecutionConfiguration [
	listElement
		stream: anAsyncStream
		executionConfiguration: anAsyncFutureExecutionConfiguration.
	self onStreamChanged
]
