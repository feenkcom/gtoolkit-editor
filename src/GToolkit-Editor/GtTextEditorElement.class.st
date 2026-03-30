Class {
	#name : 'GtTextEditorElement',
	#superclass : 'BlElement',
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'viewportTop',
		'viewportHeight',
		'semaphore',
		'editorProcess',
		'messagesQueue',
		'messagesQueueUpdater',
		'adornments',
		'stylerStrategy',
		'styler',
		'currentStyledText',
		'completionStrategy',
		'completionAttributeTag',
		'completionElement',
		'completionFuture',
		'adornmentsBank',
		'userModel',
		'history',
		'editorHandle',
		'heightSpec',
		'editorHeight'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'api - attributes' }
GtTextEditorElement >> addAttribute: anAttribute from: aStart to: anEnd [
	^ anAttribute
		asGtExternalTextAttributeForTheme: self theme
		during: [ :externalAttribute |
			| attributeTag |
			
			attributeTag := editorHandle
				addAttribute: externalAttribute
				from: aStart
				to: anEnd.
			
			externalAttribute isAdornmentAttribute
				ifTrue: [
					adornmentsBank
						at: attributeTag
						put: externalAttribute adornmentAttribute ].

			attributeTag ].
]

{ #category : 'api - attributes' }
GtTextEditorElement >> addAttribute: anAttribute from: aStart to: anEnd documentId: documentId [
	<return: #Number>
	^ anAttribute
		asGtExternalTextAttributeForTheme: self theme
		during: [ :externalAttribute |
			| attributeTag |
			
			attributeTag := editorHandle
				addAttribute: externalAttribute
				from: aStart
				to: anEnd
				documentId: documentId.
			
			externalAttribute isAdornmentAttribute
				ifTrue: [
					adornmentsBank
						at: attributeTag
						put: externalAttribute adornmentAttribute ].

			attributeTag ].
]

{ #category : 'api - attributes' }
GtTextEditorElement >> addAttribute: anAttribute overAdornment: anAdornmentId [
	<return: #Number>
	^ anAttribute
		asGtExternalTextAttributeForTheme: self theme
		during: [ :externalAttribute |
			| attributeTag |
	
			attributeTag := editorHandle
				addAttribute: externalAttribute
				overAdornment: anAdornmentId.
		
			externalAttribute isAdornmentAttribute
				ifTrue: [
					adornmentsBank
						at: attributeTag
						put: externalAttribute adornmentAttribute ].			
			attributeTag ].
]

{ #category : 'api - navigation' }
GtTextEditorElement >> addCursorAtVisualPoint: aPoint [
	
	editorHandle addCursorAtVisualPoint: aPoint
]

{ #category : 'adding' }
GtTextEditorElement >> addEditorShortcuts: aCollection [ 
	
]

{ #category : 'api - mode' }
GtTextEditorElement >> beReadOnlyWithSelection [
	
]

{ #category : 'accessing' }
GtTextEditorElement >> completionStrategy [
	^ completionStrategy
]

{ #category : 'accessing' }
GtTextEditorElement >> completionStrategy: aStrategy [
	self assert: [ aStrategy isNotNil ].
	completionStrategy := aStrategy
]

{ #category : 'api - editing' }
GtTextEditorElement >> copySelected [
	editorHandle copySelected
]

{ #category : 'api - editing' }
GtTextEditorElement >> cutSelected [
	editorHandle cutSelected
]

{ #category : 'initialization' }
GtTextEditorElement >> defaultCompletionStrategy [
	^ BrTextEditorCompletionStrategy empty
]

{ #category : 'accessing' }
GtTextEditorElement >> defaultFontName: aFontFamilyName [
	editorHandle defaultFontName: aFontFamilyName
]

{ #category : 'accessing' }
GtTextEditorElement >> defaultFontSize: aFontSize [
	editorHandle defaultFontSize: aFontSize
]

{ #category : 'accessing' }
GtTextEditorElement >> defaultForeground: aColor [
	editorHandle defaultForeground: aColor
]

{ #category : 'styling' }
GtTextEditorElement >> defaultStylerStrategy [
	^ GtTextEditorStylerAsyncStrategy new
]

{ #category : 'api - editing' }
GtTextEditorElement >> deleteNextAtCursor [
	editorHandle deleteNextAtCursor
]

{ #category : 'api - editing' }
GtTextEditorElement >> deletePreviousAtCursor [
	editorHandle deletePreviousAtCursor
]

{ #category : 'api - selection' }
GtTextEditorElement >> deselectAll [
	self flag: #TODO
]

{ #category : 'accessing' }
GtTextEditorElement >> editor [
	self flag: #TODO.

	^ self
]

{ #category : 'private' }
GtTextEditorElement >> ensureEditorProcess [
	(editorProcess isNil or: [ editorProcess isSuspended or: [ editorProcess isTerminated or: [ editorProcess isTerminating ] ] ])
		ifFalse: [ ^ self ].
		
	editorProcess := [ self runEditorProcess ] forkAt: Processor userInterruptPriority named: 'Editor'.
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionDown [
	editorHandle extendSelectionDown
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionLeft [
	editorHandle extendSelectionLeft
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionRight [
	editorHandle extendSelectionRight
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionToLineEnd [
	editorHandle extendSelectionToLineEnd
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionToLineStart [
	editorHandle extendSelectionToLineStart
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionUp [
	editorHandle extendSelectionUp
]

{ #category : 'as yet unclassified' }
GtTextEditorElement >> gtAsPhlowObjectActionFor: anAction [
	<gtAction>
	^ anAction button
		id: #'phlow--inspect-editor-handle';
		priority: 1;
		tooltip: 'Inspect editor handle';
		icon: (self class environment at: #BrGlamorousVectorIcons) rustLogo;
		action: [ :aButton | aButton phlow spawnObject: editorHandle ]
]

{ #category : 'todo' }
GtTextEditorElement >> history [
	"Do we want to this object here? I see #undo and #redo methods."

	self flag: #TODO.
	^ history ifNil: [ history := BrTextEditorHistory new ]
]

{ #category : 'todo' }
GtTextEditorElement >> history: aBrTextEditorHistory [
	"Do we want to this object here? I see #undo and #redo methods."

	self flag: #TODO.
	history := aBrTextEditorHistory
]

{ #category : 'initialization' }
GtTextEditorElement >> initialize [
	| semaphoreIndex |
	super initialize.
	self beFocusable.
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.

	adornments := OrderedDictionary new.
	adornmentsBank := OrderedDictionary new.

	styler := BlTextNullStyler new.
	stylerStrategy := self defaultStylerStrategy.

	completionStrategy := self defaultCompletionStrategy.
	completionElement := self newCompletionList.
	completionFuture := self newCompletionFuture.

	self eventDispatcher forwardShortcuts
		targetObject: completionElement;
		// GtTextEditorCompletionListId;
		forwardWhen: [ :aTargetElement | aTargetElement isAddedToSceneGraph ].

	editorHandle := GtTextEditorEmbedder
			forSemaphoreIndex: semaphoreIndex
			during: [ :pharoEmbedder | 
				messagesQueue := pharoEmbedder messagesQueue.
				GtTextEditorHandle forEmbedder: pharoEmbedder ].

	messagesQueueUpdater := BrElementUpdater new
			element: self;
			action: (MessageSend receiver: self selector: #pollEditorMessages).

	self beInSeparateCompositionLayer.
	self when: BlMouseWheelEvent do: [ :anEvent | self onMouseWheelEvent: anEvent ].
	self when: BlMouseDownEvent do: [ :anEvent | self onMouseDownEvent: anEvent ].
	self when: BlMouseUpEvent do: [ :anEvent | self onMouseUpEvent: anEvent ].
	self when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ].

	self when: BlDragStartEvent do: [ :anEvent | self onDragStartEvent: anEvent ].

	self when: BlDragEvent do: [ :anEvent | self onDragEvent: anEvent ].

	self when: BlDragEndEvent do: [ :anEvent | self onDragEndEvent: anEvent ].

	self when: BlTextInputEvent do: [ :anEvent | self onTextInputEvent: anEvent ].

	self when: BrTextStyledEvent do: [ :anEvent | self onTextStyledEvent: anEvent ].
	self initializeShortcuts
]

{ #category : 'initialization' }
GtTextEditorElement >> initializeShortcuts [
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination backspace;
				action: [ self deletePreviousAtCursor ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination delete;
				action: [ self deleteNextAtCursor ]).

	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ self insertLineBreakAtCarets ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination tab;
				action: [ self insertTabAtCaretsOrIndent ]).
	
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination shiftTab;
				action: [ self unindent ]).

	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination arrowLeft;
				action: [ self moveCursorLeft ]).

	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination shiftArrowLeft;
				action: [ self extendSelectionLeft ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination shiftArrowRight;
				action: [ self extendSelectionRight ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination shiftArrowUp;
				action: [ self extendSelectionUp ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination shiftArrowDown;
				action: [ self extendSelectionDown ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryA;
				action: [ self selectAll ]).

	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination arrowRight;
				action: [ self moveCursorRight ]).
				
		self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination arrowUp;
				action: [ self moveCaretsUp ]).

	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination arrowDown;
				action: [ self moveCaretsDown ]).

	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryC;
				action: [ self copySelected ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryX;
				action: [ self cutSelected ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryV;
				action: [ self pasteAtCarets ]).

	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryZ;
				action: [ self undo ]).
	
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryShiftZ;
				action: [ self redo ]).
	
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination builder primary home build;
				action: [ self moveCursorToBeginning ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination builder primary end build;
				action: [ self moveCursorToEnd ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryArrowLeft;
				action: [ self moveCursorToLineStart ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryArrowRight;
				action: [ self moveCursorToLineEnd ]).
		
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryShiftArrowLeft;
				action: [ self extendSelectionToLineStart ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryShiftArrowRight;
				action: [ self extendSelectionToLineEnd ])
]

{ #category : 'api - editing' }
GtTextEditorElement >> insertLineBreakAtCarets [
	self insertStringAtCursor: OSPlatform current lineEnding
]

{ #category : 'api - editing' }
GtTextEditorElement >> insertStringAtCursor: aString [
	editorHandle insertStringAtCursor: aString
]

{ #category : 'api - editing' }
GtTextEditorElement >> insertTabAtCaretsOrIndent [
	editorHandle insertTabOrIndent
]

{ #category : 'accessing' }
GtTextEditorElement >> model [
	^ userModel
]

{ #category : 'accessing' }
GtTextEditorElement >> model: anObject [
	"Users can set what ever object they need.
	Currently, we call #model in `GtSourceCoderShortcut>>#performOnEditor:element:dueTo:`,
	which is called from `GtTextualCoder>>#addContextMenuItemFrom:group:withId:to:`.
	Ideally, we would like to remove this need and pass the editor element to the method,
	which would be `GtNewTextualCoderElement`.
	We set it in `GtNewTextualCoderElement>>#onTextualCoderViewModelChanged`."
	
	self flag: #TODO.

	userModel := anObject
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCaretsDown [
	editorHandle moveCaretsDown
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCaretsUp [
	editorHandle moveCaretsUp
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorLeft [
	"Moves the cursor one letter at a time to the left from the current position and deselects any selected text."
	
	editorHandle moveCursorLeft
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorRight [
	"Moves the cursor one letter at a time to the right from the current position and deselects any selected text"
	
	editorHandle moveCursorRight
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorToBeginning [
	"Moves the cursor to the beginning of the current editor and deselects any selected text."
	
	editorHandle moveCursorToBeginning
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorToEnd [
	"Moves the cursor to the end of the current editor and deselects any selected text."
	
	editorHandle moveCursorToEnd
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorToLineEnd [
	"Moves the cursor to the end of the current line and deselects any selected text."
	
	editorHandle moveCursorToLineEnd
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorToLineStart [
	"Moves the cursor to the start of the current line and deselects any selected text."
	
	editorHandle moveCursorToLineStart
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorToVisualPoint: aPoint [	
	editorHandle moveCursorToVisualPoint: aPoint
]

{ #category : 'initialization' }
GtTextEditorElement >> newCompletionFuture [
	^ (BrAsyncElementFuture on: self)
		whenSuccess: [ :thisEditor :aCompletionRequest | 
			completionAttributeTag ifNotNil: [ :aTag |
				self removeAttributeTagged: aTag.
				completionAttributeTag := nil ].
			aCompletionRequest ifNotNil: [ 
				completionElement stream: aCompletionRequest completionStream.
				completionAttributeTag := self
						addAttribute: (GtTextEditorCompletionAttachmentAttribute new completionElement: completionElement)
						from: aCompletionRequest byteOffset
						to: aCompletionRequest byteOffset
						documentId: aCompletionRequest documentId.
				 ] ];
		whenError: [ :thisEditor :anError | completionAttributeTag ifNotNil: [ :aTag | self removeAttributeTagged: aTag ] ];
		whenPending: [ :thisEditor | ];
		yourself
]

{ #category : 'initialization' }
GtTextEditorElement >> newCompletionList [
	^ GtTextEditorCompletionSimpleListElement new
		onComplete: [ :selectedItem | self onCompleteWithSelectedItem: selectedItem ]
]

{ #category : 'hooks - children' }
GtTextEditorElement >> onAddedToSceneGraph [
	| window |
	super onAddedToSceneGraph.

	window := ExternalAddress null.

	self
		spaceDo: [ :aSpace | 
			aSpace
				hostSpaceDo: [ :aHostSpace | 
					window := aHostSpace window ] ].

	editorHandle setRenderThreadWakerThunk: window.

	self ensureEditorProcess
]

{ #category : 'event handling' }
GtTextEditorElement >> onClickEvent: anEvent [
	anEvent consumed: true
]

{ #category : 'event handling' }
GtTextEditorElement >> onCompleteWithSelectedItem: selectedItem [
	
	(selectedItem isNil or: [ selectedItem isEmpty ])
		ifFalse: [ "self phlow spawnObject: selectedItem" ].

		completionAttributeTag ifNotNil: [ :aTag | self removeAttributeTagged: aTag ].
]

{ #category : 'event handling' }
GtTextEditorElement >> onDragEndEvent: anEvent [
	anEvent consumed: true.
	
	editorHandle endSelectionAtVisualPoint
]

{ #category : 'event handling' }
GtTextEditorElement >> onDragEvent: anEvent [
	anEvent consumed: true.
	
	editorHandle updateSelectionAtVisualPoint: anEvent localPosition
]

{ #category : 'event handling' }
GtTextEditorElement >> onDragStartEvent: anEvent [
	anEvent consumed: true.
	
	editorHandle startSelectionAtVisualPoint: anEvent localPosition
]

{ #category : 'event handling' }
GtTextEditorElement >> onEditorActiveCaretMoved: aMessage [
	self dispatchEvent: (BrTextEditorCursorChangedEvent new cursors: (BrTextEditorCursor at: aMessage newOffset))
]

{ #category : 'event handling' }
GtTextEditorElement >> onEditorAdornmentMeasured: aMessage [
	adornments
		at: aMessage adornmentTag
		ifPresent: [ :anAssociation |
			| anAdornmentAttribute aTextPiece theAdornmentElements |
			
			anAdornmentAttribute := anAssociation key.
			theAdornmentElements := anAssociation value.
			theAdornmentElements ifNil: [
				aTextPiece := GtTextEditorTextPiece new
					initializeWith: (GtTextEditorTextOfAdornment new setEditorElement: self adornmentId: aMessage adornmentTag)
					from: 0
					to: 0
					delimiter: 0.
				
				theAdornmentElements := (anAdornmentAttribute affect: aTextPiece in: self) asOrderedCollection.
				theAdornmentElements do: [ :each |
					each userData at: #editorAdornmentId put:aMessage adornmentTag
				].
				self addChildren: theAdornmentElements.
				anAssociation value: theAdornmentElements
			].
		]
		ifAbsent: [
		
		]
]

{ #category : 'event handling' }
GtTextEditorElement >> onEditorAdornmentsAdded: aMessage [
	aMessage adornmentTags do: [ :eachTag |
		adornmentsBank
			at: eachTag
			ifPresent: [ :eachValue |
				adornments
					at: eachTag
					ifAbsent: [
						adornments at: eachTag put: (eachValue -> nil)
					] ] ].
]

{ #category : 'event handling' }
GtTextEditorElement >> onEditorAdornmentsRemoved: aMessage [
	| removedTags removedElements |
	
	removedTags := aMessage adornmentTags.
	removedTags do: [ :eachTag |
		adornments removeKey: eachTag ifAbsent: [ ].
		adornmentsBank removeKey: eachTag ifAbsent: [ ] ].
	
	removedTags := removedTags asSet.
	
	removedElements := self children
			select: [ :eachChild | 
				eachChild userData
					at: #editorAdornmentId
					ifPresent: [ :anAdornmentTag | removedTags includes: anAdornmentTag ]
					ifAbsent: [ false ] ].

	self removeChildren: removedElements. 
]

{ #category : 'event handling' }
GtTextEditorElement >> onEditorLayoutReady: aMessage [	
	self ignoreRequestLayoutDuring:  [
	
		self children
			do: [ :eachChild | 
				eachChild userData
					at: #editorAdornmentId
					ifPresent: [ :anAdornmentTag | 
						aMessage
							adornmentPosition: anAdornmentTag
							ifPresent: [ :adornmentPosition |
								eachChild relocate: adornmentPosition ]
							ifAbsent: [  ] ] ] ].
	
	(aMessage editorExtent closeTo: self measuredExtent)
		ifFalse: [ self requestLayout ]
]

{ #category : 'event handling' }
GtTextEditorElement >> onEditorMeasureAdornment: aMessage [
	adornments
		at: aMessage adornmentTag
		ifPresent: [ :anAssociation |
			| anAdornmentAttribute aTextPiece theAdornmentElements |
			
			anAdornmentAttribute := anAssociation key.
			theAdornmentElements := anAssociation value.
			theAdornmentElements ifNil: [
				aTextPiece := GtTextEditorTextPiece new
					initializeWith: (GtTextEditorTextOfAdornment new setEditorElement: self adornmentId: aMessage adornmentTag)
					from: 0
					to: 0
					delimiter: 0.
				
				theAdornmentElements := (anAdornmentAttribute affect: aTextPiece in: self) asOrderedCollection.
				theAdornmentElements do: [ :each |
					each userData at: #editorAdornmentId put:aMessage adornmentTag
				].
				self addChildren: theAdornmentElements.
				anAssociation value: theAdornmentElements
			].
		]
		ifAbsent: [ ]
]

{ #category : 'event handling' }
GtTextEditorElement >> onEditorTextChanged: aMessage [
	self dispatchEvent: BrTextEditorModifiedEvent new.
]

{ #category : 'event handling' }
GtTextEditorElement >> onEditorTextCompletionRequest: aMessage [
	| contextBeforeCaret completionPrefix completionResult completionOffset completionRequest hasCompletionsFuture|
	
	contextBeforeCaret := aMessage contextBeforeCaret.
	
	completionPrefix := (completionStrategy
		completionPrefixAt: contextBeforeCaret size
		in: contextBeforeCaret ) ifNil: [ '' ].
		
	completionOffset := (ZnUTF8Encoder default encodeString: completionPrefix) size.
		
	completionResult := completionStrategy
		completionResultFor: contextBeforeCaret
		at: contextBeforeCaret size
		requested: aMessage trigger isManual.
		
	completionRequest := GtTextEditorCompletionRequest new
		completionStream: completionResult asAsyncStream;
		byteOffset: ((aMessage caretRawOffset + 1 - completionOffset) max: 0);
		documentId: aMessage documentId.
		
	hasCompletionsFuture := completionResult asAsyncStream hasNext map: [ :hasNext |
		hasNext
			ifTrue: [ completionRequest ]
			ifFalse: [ nil ] ].

	completionFuture future: hasCompletionsFuture
]

{ #category : 'event handling' }
GtTextEditorElement >> onEditorTextStylingRequest: aMessage [
	| textToStyle |
	
	textToStyle := GtTextEditorTextToStyle new
		setExternalText: aMessage unstyledText
		documentId: aMessage documentId
		theme: self theme.
	
	self stylerStrategy
		styleText: textToStyle
		inEditorElement: self
		thenDo: [ :aText | ]
]

{ #category : 'layout' }
GtTextEditorElement >> onMeasure: anExtentMeasurementSpec [
	super onMeasure: anExtentMeasurementSpec.
	
	self children accountedByLayout do: [ :eachChild |
		eachChild userData
			at: #editorAdornmentId
			ifPresent: [ :anAdornmentTag |
				editorHandle
					resizeAdornment: anAdornmentTag
					extent: eachChild measuredExtent
			]
	].
	
	heightSpec := anExtentMeasurementSpec heightSpec.
	
	viewportTop := anExtentMeasurementSpec viewport
		ifNotNil: [ :aViewport | aViewport bounds top ].
		
	viewportHeight := anExtentMeasurementSpec viewport
		ifNotNil: [ :aViewport | aViewport bounds height ].

	viewportHeight := heightSpec isUnspecified
		ifTrue: [ viewportHeight ]
		ifFalse: [
			viewportHeight
				ifNil: [ heightSpec size ]
				ifNotNil: [ viewportHeight min: heightSpec size ] ].

	editorHandle
		measureWidth: self measuredWidth
		top: viewportTop
		height: viewportHeight.
		
	editorHeight := editorHandle height.
		
	self measuredExtent: (anExtentMeasurementSpec sizeFor: (self measuredWidth @ editorHeight))
]

{ #category : 'event handling' }
GtTextEditorElement >> onMouseDownEvent: anEvent [
	anEvent consumed: true.
	
	anEvent modifiers isAlt
		ifTrue: [ self addCursorAtVisualPoint: anEvent localPosition ]
		ifFalse: [ self moveCursorToVisualPoint: anEvent localPosition ].
		
	self requestFocus
]

{ #category : 'event handling' }
GtTextEditorElement >> onMouseUpEvent: anEvent [
	anEvent consumed: true
]

{ #category : 'event handling' }
GtTextEditorElement >> onMouseWheelEvent: anEvent [
	(self constraints vertical resizer isFitContent
		and: [ self constraints vertical resizer isFitContentLimited not ])
			ifTrue: [ ^ self ].

	anEvent consumed: true.
	
	editorHandle scrollBy: anEvent vector y
]

{ #category : 'hooks - children' }
GtTextEditorElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	
	editorHandle setRenderThreadWakerThunk: ExternalAddress null.
	
	editorProcess ifNotNil: [ :aProcess | aProcess terminate ].
	editorProcess := nil
]

{ #category : 'event handling' }
GtTextEditorElement >> onTextInputEvent: anEvent [
	(anEvent text allSatisfy: [ :aCharacter | Unicode isPrintable: aCharacter ])
		ifFalse: [ ^ self ].
	
	anEvent modifiers isPrimaryModifier
		ifTrue: [ ^ self ].
	
	anEvent consumed: true.
  editorHandle insertStringAtCursor: anEvent text
]

{ #category : 'event handling' }
GtTextEditorElement >> onTextStyledEvent: anEvent [
	anEvent afterAction value: anEvent text.
	self styledText: anEvent text
]

{ #category : 'painting' }
GtTextEditorElement >> paintMeAndChildrenOn: aCompositorPainter offset: anOffset [
	| viewportOffset textureExtent externalMethods  |
	self errorHandler
		with: self
		do: [ self paintOn: aCompositorPainter offset: anOffset ]
		failed: [ :anError | 
			aCompositorPainter canvas fill
				paint: Color lightGray;
				path: self boundsInLocal;
				draw ].

	viewportOffset := 0 @ (viewportTop ifNil: [ 0.0 ]).

	textureExtent := self extent - viewportOffset.

	externalMethods := GtTextEditorExternalMethods current.
	
	aCompositorPainter
		pushLayer: (BlCompositionOffsetLayer new
				offset: anOffset + viewportOffset;
				addLayer: (BlCompositionBorrowedTextureLayer new
						extent: textureExtent;
						callback: externalMethods drawFn;
						payload: editorHandle))
		offset: anOffset
		bounds: self invalidationBounds
		compositing: BlCompositingSeparateLayerMode uniqueInstance
		thenPaint: [ :aNewPainter :aNewOffset |  ].
		
	"self paintChildrenOn: aCompositorPainter offset: anOffset."

	aCompositorPainter
		pushChildren: self children sortedByElevation
		offset: anOffset
		compositing: BlCompositingSeparateLayerMode uniqueInstance
		thenPaint: [ :aChildElement :aChildPainter :aChildOffset | 
			aChildElement userData
				at: #editorAdornmentId
				ifPresent: [ :anAdornmentTag | 
					aChildPainter
						pushLayer: (BlCompositionDynamicOffsetLayer new
										setOffsetFn: externalMethods offsetFn
										payload: (editorHandle primCreateAdornmentDynamicOffset: anAdornmentTag)
										cloneFn: externalMethods payloadCloneFn
										freeFn: externalMethods payloadFreeFn)
						offset: aChildOffset - aChildElement position
						bounds: self invalidationBounds
						compositing: aChildElement compositingMode
						thenPaint: [ :aNewPainter :aNewOffset |
							aChildElement fullPaintOn: aNewPainter offset: aNewOffset ] ] ]
]

{ #category : 'api - editing' }
GtTextEditorElement >> pasteAtCarets [
	editorHandle pasteAtCarets
]

{ #category : 'private' }
GtTextEditorElement >> pollEditorMessages [
	[ 
		messagesQueue
			pollMessageDuring: [ :aMessage | aMessage sendTo: self ]
			ifAbsent: [ ^ self ]
	] repeat
]

{ #category : 'styling' }
GtTextEditorElement >> privateDoStyleTextAndAfterDo: aBlock [
	"Actually trigger a text styler"
	
	(BlTextStylerRequestedSignal new element: self) emit.
	
	self stylerStrategy
		styleTextInEditorElement: self
		thenDo: aBlock
]

{ #category : 'private' }
GtTextEditorElement >> privateEditorHandle [
	^ editorHandle
]

{ #category : 'api - editing' }
GtTextEditorElement >> redo [
	editorHandle redo
]

{ #category : 'api - attributes' }
GtTextEditorElement >> removeAttributeTagged: anAttributeTag [
	editorHandle
		removeAttributeTagged: anAttributeTag
]

{ #category : 'api - attributes' }
GtTextEditorElement >> removeAttributeTagged: anAttributeTag overAdornment: anAdornmentTag [
	editorHandle
		removeAttributeTagged: anAttributeTag
		overAdornment: anAdornmentTag	
]

{ #category : 'removing' }
GtTextEditorElement >> removeEditorShortcuts: aCollection [ 
	
]

{ #category : 'removing' }
GtTextEditorElement >> removeTextAttribute: aGtCompletionAttachmentAttribute [
	
]

{ #category : 'styling' }
GtTextEditorElement >> requestAutoStyling [
	editorHandle requestStyling: GtTextEditorStylingTrigger Auto
]

{ #category : 'styling' }
GtTextEditorElement >> requestManualStyling [
	editorHandle requestStyling: GtTextEditorStylingTrigger Manual
]

{ #category : 'accessing' }
GtTextEditorElement >> resetCompletionStrategy [
	completionStrategy := self defaultCompletionStrategy
]

{ #category : 'api - save state' }
GtTextEditorElement >> restoreState: aMemento [
	aMemento restoreStateOfNewEditor: self
]

{ #category : 'todo' }
GtTextEditorElement >> restoreText: aBlRunRopedText [ 
	self text: aBlRunRopedText
]

{ #category : 'private' }
GtTextEditorElement >> runEditorProcess [
	[
		semaphore wait.
		messagesQueueUpdater requestUpdate
	] repeat
]

{ #category : 'api - selection' }
GtTextEditorElement >> selectAll [
	editorHandle selectAll
]

{ #category : 'styling' }
GtTextEditorElement >> styleText [
	"For explicit manual styling, there is #requestManualStyling"

	GtJustContextStackSignal emit
]

{ #category : 'styling' }
GtTextEditorElement >> styleTextAndAfterDo: aConstantBlockClosure1Arg [ 
	self flag: #TODO.
]

{ #category : 'styling' }
GtTextEditorElement >> styledText: aTextToStyle [
	currentStyledText := aTextToStyle.

	aTextToStyle
		asGtTextEditorTextForTheme: self theme
		during: [ :textEditorText |
			self flag: #TODO.
			"questionable! What should we do when the styled text is rejected because of the wrong document id"
			
			adornmentsBank addAll: textEditorText adornments.
			
			editorHandle
				styledText: textEditorText
				documentId: aTextToStyle documentId ]
]

{ #category : 'styling' }
GtTextEditorElement >> styler [
	^ styler
]

{ #category : 'styling' }
GtTextEditorElement >> styler: aStyler [
	styler = aStyler ifTrue: [ ^ self ].

	styler := aStyler.

	self requestManualStyling.
]

{ #category : 'styling' }
GtTextEditorElement >> stylerStrategy [
	^ stylerStrategy
]

{ #category : 'accessing' }
GtTextEditorElement >> text [
	"Funny enough, users should not be able to get a text from an editor.
	Instead, they should listen to text changes events.
	The reason why we can't offer a text accessor is because the editor
	lives outside of the Pharo memory and bringing a text into pharo is expensive."
	self flag: #TODO.
	
	^ self unstyledText asRopedText
]

{ #category : 'accessing' }
GtTextEditorElement >> text: aBlText [
	aBlText
		asGtTextEditorTextForTheme: self theme
		during: [ :textEditorText |
			adornmentsBank addAll: textEditorText adornments.
			editorHandle text: textEditorText ]
]

{ #category : 'api - editing' }
GtTextEditorElement >> undo [
	editorHandle undo
]

{ #category : 'api - editing' }
GtTextEditorElement >> unindent [
	editorHandle unindent
]

{ #category : 'styling' }
GtTextEditorElement >> unstyledText [
	self flag: #TODO.
	
	^ editorHandle unstyledText
]
