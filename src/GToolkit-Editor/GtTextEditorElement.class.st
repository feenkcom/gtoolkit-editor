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
GtTextEditorElement >> ensureEditorProcess [
	(editorProcess isNil or: [ editorProcess isSuspended or: [ editorProcess isTerminated or: [ editorProcess isTerminating ] ] ])
		ifFalse: [ ^ self ].
		
	editorProcess := [ self runEditorProcess ] forkAt: Processor userInterruptPriority named: 'Editor'.
]

{ #category : #'as yet unclassified' }
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

	self
		when: BlClickEvent
		do: [ :anEvent | 
			anEvent consumed: true.
			self requestFocus ].

	self when: BlTextInputEvent do: [ :anEvent | self onTextInputEvent: anEvent ].
	
	self addShortcut: (BlShortcutWithAction new combination: BlKeyCombination arrowLeft;
				action: [ self moveCursorLeft ]).
				
	self addShortcut: (BlShortcutWithAction new combination: BlKeyCombination arrowRight;
				action: [ self moveCursorRight ]).
				
	self addShortcut: (BlShortcutWithAction new combination: BlKeyCombination primaryV;
				action: [ self pasteString ]).
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> insertStringAtCursor: aString [
	editorModel insertStringAtCursor: aString
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> moveCursorLeft [
	editorModel moveCursorLeft
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> moveCursorRight [
	editorModel moveCursorRight
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
GtTextEditorElement >> onMouseWheelEvent: anEvent [
	self constraints vertical resizer isFitContent
		ifTrue: [ ^ self ].

	anEvent consumed: true.
	
	editorModel scrollBy: anEvent vector y
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	
	editorModel setRenderThreadWakerThunk: ExternalAddress null.
	
	editorProcess ifNotNil: [ :aProcess | aProcess terminate ].
	editorProcess := nil
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> onTextInputEvent: anEvent [
	anEvent consumed: true.

	editorModel insertStringAtCursor: anEvent text
]

{ #category : #'as yet unclassified' }
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
