Class {
	#name : #GtTextEditorElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'editorModel',
		'viewportTop',
		'viewportHeight',
		'semaphore',
		'editorProcess'
	],
	#category : #'GToolkit-Editor-UI'
}

{ #category : #'as yet unclassified' }
GtTextEditorElement >> addAttribute: anAttribute from: aStart to: anEnd [
	editorModel addAttribute: anAttribute from: aStart to: anEnd
]

{ #category : #'api - navigation' }
GtTextEditorElement >> addCursorAtVisualPoint: aPoint [
	
	editorModel addCursorAtVisualPoint: aPoint
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> ensureEditorProcess [
	(editorProcess isNil or: [ editorProcess isSuspended or: [ editorProcess isTerminated or: [ editorProcess isTerminating ] ] ])
		ifFalse: [ ^ self ].
		
	editorProcess := [ self runEditorProcess ] forkAt: Processor userInterruptPriority named: 'Editor'.
]

{ #category : #initialization }
GtTextEditorElement >> initialize [
	| semaphoreIndex |
	super initialize.
	self beFocusable.
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	editorModel := GtTextEditorHandle forSemaphoreIndex: semaphoreIndex.
	self beInSeparateCompositionLayer.
	self addAptitude: BrGlamorousTextAreaSpacingAptitude.
	self when: BlMouseWheelEvent do: [ :anEvent | self onMouseWheelEvent: anEvent ].
	self when: BlMouseDownEvent do: [ :anEvent | self onMouseDownEvent: anEvent ].
	self when: BlMouseUpEvent do: [ :anEvent | self onMouseUpEvent: anEvent ].
	self when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ].

	self when: BlDragStartEvent do: [ :anEvent | self onDragStartEvent: anEvent ].

	self when: BlDragEvent do: [ :anEvent | self onDragEvent: anEvent ].

	self when: BlDragEndEvent do: [ :anEvent | self onDragEndEvent: anEvent ].

	self when: BlTextInputEvent do: [ :anEvent | self onTextInputEvent: anEvent ].
	self initializeShortcuts
]

{ #category : #initialization }
GtTextEditorElement >> initializeShortcuts [
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination arrowLeft;
				action: [ self moveCursorLeft ]).

	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination arrowRight;
				action: [ self moveCursorRight ]).

	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryV;
				action: [ self pasteString ]).

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
				combination: BlKeyCombination home;
				action: [ self moveCursorToLineStart ]).
				
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination end;
				action: [ self moveCursorToLineEnd ])
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> insertStringAtCursor: aString [
	editorModel insertStringAtCursor: aString
]

{ #category : #'api - navigation' }
GtTextEditorElement >> moveCursorLeft [
	"Moves the cursor one letter at a time to the left from the current position and deselects any selected text."
	
	editorModel moveCursorLeft
]

{ #category : #'api - navigation' }
GtTextEditorElement >> moveCursorRight [
	"Moves the cursor one letter at a time to the right from the current position and deselects any selected text"
	
	editorModel moveCursorRight
]

{ #category : #'api - navigation' }
GtTextEditorElement >> moveCursorToBeginning [
	"Moves the cursor to the beginning of the current editor and deselects any selected text."
	
	editorModel moveCursorToBeginning
]

{ #category : #'api - navigation' }
GtTextEditorElement >> moveCursorToEnd [
	"Moves the cursor to the end of the current editor and deselects any selected text."
	
	editorModel moveCursorToEnd
]

{ #category : #'api - navigation' }
GtTextEditorElement >> moveCursorToLineEnd [
	"Moves the cursor to the end of the current line and deselects any selected text."
	
	editorModel moveCursorToLineEnd
]

{ #category : #'api - navigation' }
GtTextEditorElement >> moveCursorToLineStart [
	"Moves the cursor to the start of the current line and deselects any selected text."
	
	editorModel moveCursorToLineStart
]

{ #category : #'api - navigation' }
GtTextEditorElement >> moveCursorToVisualPoint: aPoint [	
	editorModel moveCursorToVisualPoint: aPoint
]

{ #category : #'hooks - children' }
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

{ #category : #initialization }
GtTextEditorElement >> onClickEvent: anEvent [
	anEvent consumed: true
]

{ #category : #initialization }
GtTextEditorElement >> onDragEndEvent: anEvent [
	anEvent consumed: true.
	
	editorModel endSelectionAtVisualPoint
]

{ #category : #initialization }
GtTextEditorElement >> onDragEvent: anEvent [
	anEvent consumed: true.
	
	editorModel updateSelectionAtVisualPoint: anEvent localPosition
]

{ #category : #initialization }
GtTextEditorElement >> onDragStartEvent: anEvent [
	anEvent consumed: true.
	
	editorModel startSelectionAtVisualPoint: anEvent localPosition
]

{ #category : #layout }
GtTextEditorElement >> onMeasure: anExtentMeasurementSpec [
	| heightSpec |
	super onMeasure: anExtentMeasurementSpec.
	
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

{ #category : #initialization }
GtTextEditorElement >> onMouseDownEvent: anEvent [
	anEvent consumed: true.
	
	anEvent modifiers isAlt
		ifTrue: [ self addCursorAtVisualPoint: anEvent localPosition ]
		ifFalse: [ self moveCursorToVisualPoint: anEvent localPosition ].
		
	self requestFocus. 
]

{ #category : #initialization }
GtTextEditorElement >> onMouseUpEvent: anEvent [
	anEvent consumed: true
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> onMouseWheelEvent: anEvent [
	self constraints vertical resizer isFitContent
		ifTrue: [ ^ self ].

	anEvent consumed: true.
	
	editorModel scrollBy: anEvent vector y
]

{ #category : #'hooks - children' }
GtTextEditorElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	
	editorModel setRenderThreadWakerThunk: ExternalAddress null.
	
	editorProcess ifNotNil: [ :aProcess | aProcess terminate ].
	editorProcess := nil
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> onTextInputEvent: anEvent [
	(anEvent text allSatisfy: [ :aCharacter | Unicode isPrintable: aCharacter ])
		ifFalse: [ ^ self ].

    anEvent consumed: true.

	editorModel insertStringAtCursor: anEvent text
]

{ #category : #'event handling' }
GtTextEditorElement >> paintMeAndChildrenOn: aCompositorPainter offset: anOffset [
	| drawMethod viewportOffset textureExtent |
	super paintMeAndChildrenOn: aCompositorPainter offset: anOffset.

	drawMethod := FFIBackend current
			loadSymbol: #editor_draw
			module: GtTextEditorLibrary uniqueInstance libraryName.

	viewportOffset := 0 @ (viewportTop ifNil: [ 0.0 ]).
	
	textureExtent := self extent - viewportOffset.

	aCompositorPainter
		pushLayer: (BlCompositionOffsetLayer new
				offset: anOffset + viewportOffset;
				addLayer: (BlCompositionBorrowedTextureLayer new
						extent: textureExtent;
						callback: drawMethod;
						payload: editorModel))
		offset: anOffset
		bounds: self invalidationBounds
		compositing: BlCompositingSeparateLayerMode uniqueInstance
		thenPaint: [ :aNewPainter :aNewOffset |  ]
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> pasteString [
	editorModel insertStringAtCursor: Clipboard clipboardText asString
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> runEditorProcess [
	[
		semaphore wait.
		self enqueueTask: (BlTaskAction new action: [ self requestLayout ])
	] repeat
]
