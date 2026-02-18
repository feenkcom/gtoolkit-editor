Class {
	#name : 'GtTextEditorElement',
	#superclass : 'BlElement',
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'editorModel',
		'viewportTop',
		'viewportHeight',
		'semaphore',
		'editorProcess',
		'messagesQueue',
		'messagesQueueUpdater',
		'adornments',
		'stylerStrategy',
		'styler',
		'currentStyledText'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'api - attributes' }
GtTextEditorElement >> addAttribute: anAttribute from: aStart to: anEnd [
	anAttribute
		asGtExternalTextAttributeForTheme: self theme
		during: [ :externalAttribute |
			| attributeTag |
			
			attributeTag := editorModel
				addAttribute: externalAttribute
				from: aStart
				to: anEnd.
			
			externalAttribute isAdornmentAttribute
				ifTrue: [
					adornments
						at: attributeTag
						put: (externalAttribute adornmentAttribute -> nil) ].

			attributeTag ].
]

{ #category : 'api - attributes' }
GtTextEditorElement >> addAttribute: anAttribute overAdornment: anAdornmentId [
	<return: #Number>
	^ anAttribute
		asGtExternalTextAttributeForTheme: self theme
		during: [ :externalAttribute |
			| attributeTag |
	
			attributeTag := editorModel
				addAttribute: externalAttribute
				overAdornment: anAdornmentId.
		
			externalAttribute isAdornmentAttribute
				ifTrue: [
					adornments
						at: attributeTag
						put: (externalAttribute adornmentAttribute -> nil) ].			
			attributeTag ].
]

{ #category : 'api - navigation' }
GtTextEditorElement >> addCursorAtVisualPoint: aPoint [
	
	editorModel addCursorAtVisualPoint: aPoint
]

{ #category : 'as yet unclassified' }
GtTextEditorElement >> addEditorShortcuts: aCollection [ 
	
]

{ #category : 'as yet unclassified' }
GtTextEditorElement >> beReadOnlyWithSelection [
	
]

{ #category : 'api - editing' }
GtTextEditorElement >> copySelected [
	editorModel copySelected
]

{ #category : 'api - editing' }
GtTextEditorElement >> cutSelected [
	editorModel cutSelected
]

{ #category : 'accessing' }
GtTextEditorElement >> defaultFontName: aFontFamilyName [
	editorModel defaultFontName: aFontFamilyName
]

{ #category : 'accessing' }
GtTextEditorElement >> defaultFontSize: aFontSize [
	editorModel defaultFontSize: aFontSize
]

{ #category : 'accessing' }
GtTextEditorElement >> defaultForeground: aColor [
	editorModel defaultForeground: aColor
]

{ #category : 'styling' }
GtTextEditorElement >> defaultStylerStrategy [
	^ GtTextEditorStylerAsyncStrategy new
]

{ #category : 'api - editing' }
GtTextEditorElement >> deleteNextAtCursor [
	editorModel deleteNextAtCursor
]

{ #category : 'api - editing' }
GtTextEditorElement >> deletePreviousAtCursor [
	editorModel deletePreviousAtCursor
]

{ #category : 'accessing' }
GtTextEditorElement >> editor [
	^ self
]

{ #category : 'accessing' }
GtTextEditorElement >> editorModel [
	^ editorModel
]

{ #category : 'private' }
GtTextEditorElement >> ensureEditorProcess [
	(editorProcess isNil or: [ editorProcess isSuspended or: [ editorProcess isTerminated or: [ editorProcess isTerminating ] ] ])
		ifFalse: [ ^ self ].
		
	editorProcess := [ self runEditorProcess ] forkAt: Processor userInterruptPriority named: 'Editor'.
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionDown [
	editorModel extendSelectionDown
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionLeft [
	editorModel extendSelectionLeft
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionRight [
	editorModel extendSelectionRight
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionToLineEnd [
	editorModel extendSelectionToLineEnd
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionToLineStart [
	editorModel extendSelectionToLineStart
]

{ #category : 'api - selection' }
GtTextEditorElement >> extendSelectionUp [
	editorModel extendSelectionUp
]

{ #category : 'as yet unclassified' }
GtTextEditorElement >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: super gtDefaultInspectorTool;
		addTool: (GtTextEditorInspectorTool new
				object: (GtWrappedTextEditorElementForInspector new editorElement: self))
]

{ #category : 'initialization' }
GtTextEditorElement >> initialize [
	| semaphoreIndex |
	super initialize.
	self beFocusable.
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	
	adornments := OrderedDictionary new.
	
	styler := BlTextNullStyler new.
	stylerStrategy := self defaultStylerStrategy.
	
	editorModel := (GtTextEditorEmbedder
			forSemaphoreIndex: semaphoreIndex
			during: [ :pharoEmbedder |
					messagesQueue := pharoEmbedder messagesQueue.
					GtTextEditorHandle forEmbedder: pharoEmbedder ]).

	messagesQueueUpdater := BrElementUpdater new
		element: self;
		action: (MessageSend receiver: self selector: #pollEditorMessages).

	self beInSeparateCompositionLayer.
	"self addAptitude: BrGlamorousTextAreaSpacingAptitude."
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
	editorModel insertStringAtCursor: aString
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCaretsDown [
	editorModel moveCaretsDown
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCaretsUp [
	editorModel moveCaretsUp
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorLeft [
	"Moves the cursor one letter at a time to the left from the current position and deselects any selected text."
	
	editorModel moveCursorLeft
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorRight [
	"Moves the cursor one letter at a time to the right from the current position and deselects any selected text"
	
	editorModel moveCursorRight
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorToBeginning [
	"Moves the cursor to the beginning of the current editor and deselects any selected text."
	
	editorModel moveCursorToBeginning
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorToEnd [
	"Moves the cursor to the end of the current editor and deselects any selected text."
	
	editorModel moveCursorToEnd
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorToLineEnd [
	"Moves the cursor to the end of the current line and deselects any selected text."
	
	editorModel moveCursorToLineEnd
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorToLineStart [
	"Moves the cursor to the start of the current line and deselects any selected text."
	
	editorModel moveCursorToLineStart
]

{ #category : 'api - navigation' }
GtTextEditorElement >> moveCursorToVisualPoint: aPoint [	
	editorModel moveCursorToVisualPoint: aPoint
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

	editorModel setRenderThreadWakerThunk: window.

	self ensureEditorProcess
]

{ #category : 'event handling' }
GtTextEditorElement >> onClickEvent: anEvent [
	anEvent consumed: true
]

{ #category : 'event handling' }
GtTextEditorElement >> onDragEndEvent: anEvent [
	anEvent consumed: true.
	
	editorModel endSelectionAtVisualPoint
]

{ #category : 'event handling' }
GtTextEditorElement >> onDragEvent: anEvent [
	anEvent consumed: true.
	
	editorModel updateSelectionAtVisualPoint: anEvent localPosition
]

{ #category : 'event handling' }
GtTextEditorElement >> onDragStartEvent: anEvent [
	anEvent consumed: true.
	
	editorModel startSelectionAtVisualPoint: anEvent localPosition
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
		ifAbsent: [ ]
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
	"self styleText"
]

{ #category : 'layout' }
GtTextEditorElement >> onMeasure: anExtentMeasurementSpec [
	| heightSpec |
	super onMeasure: anExtentMeasurementSpec.
	
	self children accountedByLayout do: [ :eachChild |
		eachChild userData
			at: #editorAdornmentId
			ifPresent: [ :anAdornmentTag |
				editorModel
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

	editorModel
		measureWidth: self measuredWidth
		top: viewportTop
		height: viewportHeight.
		
	self measuredExtent: (anExtentMeasurementSpec sizeFor: (self measuredWidth @ editorModel height))
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
	self constraints vertical resizer isFitContent
		ifTrue: [ ^ self ].

	anEvent consumed: true.
	
	editorModel scrollBy: anEvent vector y
]

{ #category : 'hooks - children' }
GtTextEditorElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	
	editorModel setRenderThreadWakerThunk: ExternalAddress null.
	
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
  editorModel insertStringAtCursor: anEvent text
]

{ #category : 'event handling' }
GtTextEditorElement >> onTextStyledEvent: anEvent [
	anEvent afterAction value: anEvent text.
	self styledText: anEvent text
]

{ #category : 'event handling' }
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
						payload: editorModel))
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
										payload: (editorModel primCreateAdornmentDynamicOffset: anAdornmentTag)
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
	editorModel pasteAtCarets
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

{ #category : 'api - editing' }
GtTextEditorElement >> redo [
	editorModel redo
]

{ #category : 'api - attributes' }
GtTextEditorElement >> removeAttributeTagged: anAttributeTag overAdornment: anAdornmentTag [
	(adornments removeKey: anAttributeTag ifAbsent: [ nil ]) ifNotNil: [ :anAssociation |
		anAssociation value ifNotNil: [ :anElement | self removeChildren: anElement ] ].

	editorModel
		removeAttributeTagged: anAttributeTag
		overAdornment: anAdornmentTag	
]

{ #category : 'as yet unclassified' }
GtTextEditorElement >> removeEditorShortcuts: aCollection [ 
	
]

{ #category : 'as yet unclassified' }
GtTextEditorElement >> removeObsoleteAdornmentElements [
	| obsoleteElements |
	obsoleteElements := self children
			reject: [ :eachChild | 
				eachChild userData
					at: #editorAdornmentId
					ifPresent: [ :anAdornmentTag | adornments includesKey: anAdornmentTag ]
					ifAbsent: [ true ] ].

	self removeChildren: obsoleteElements
]

{ #category : 'as yet unclassified' }
GtTextEditorElement >> removeTextAttribute: aGtCompletionAttachmentAttribute [
	
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
	editorModel selectAll
]

{ #category : 'as yet unclassified' }
GtTextEditorElement >> styleText [
	| textToStyle |
	textToStyle := GtTextEditorTextToStyle new setExternalText: self unstyledText theme: self theme.
	self stylerStrategy
		styleText: textToStyle
		inEditorElement: self
		thenDo: [ :aText | ]
]

{ #category : 'as yet unclassified' }
GtTextEditorElement >> styleTextAndAfterDo: aConstantBlockClosure1Arg [ 
	self flag: #TODO.
]

{ #category : 'styling' }
GtTextEditorElement >> styledText: aTextToStyle [
	currentStyledText := aTextToStyle.

	aTextToStyle
		asGtTextEditorTextForTheme: self theme
		during: [ :textEditorText |
			adornments := textEditorText adornments collect: [ :eachAttribute | eachAttribute -> nil ].
			self removeObsoleteAdornmentElements.
			self editorModel styledText: textEditorText ]
]

{ #category : 'styling' }
GtTextEditorElement >> styler [
	^ styler
]

{ #category : 'styling' }
GtTextEditorElement >> styler: aStyler [
	styler := aStyler
]

{ #category : 'styling' }
GtTextEditorElement >> stylerStrategy [
	^ stylerStrategy
]

{ #category : 'as yet unclassified' }
GtTextEditorElement >> text [
	^ self unstyledText asRopedText
]

{ #category : 'accessing' }
GtTextEditorElement >> text: aBlText [
	aBlText
		asGtTextEditorTextForTheme: self theme
		during: [ :textEditorText |
			adornments := textEditorText adornments collect: [ :eachAttribute | eachAttribute -> nil ].
			self removeObsoleteAdornmentElements.
			self editorModel text: textEditorText ]
]

{ #category : 'api - editing' }
GtTextEditorElement >> undo [
	editorModel undo
]

{ #category : 'styling' }
GtTextEditorElement >> unstyledText [
	^ editorModel unstyledText
]
