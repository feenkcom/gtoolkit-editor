Class {
	#name : #GtTextEditorElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'editorModel',
		'viewportTop',
		'viewportHeight'
	],
	#category : #'GToolkit-Editor-UI'
}

{ #category : #'as yet unclassified' }
GtTextEditorElement >> initialize [
	super initialize.
	
	editorModel := ExternalAddress null.
	
	self
		when: BlMouseWheelEvent
		do: [ :anEvent | self onMouseWheelEvent: anEvent  ].
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
		
	self measuredExtent: (self measuredWidth @ editorModel height).

	self invalidate
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> onMouseWheelEvent: anEvent [
	self constraints vertical resizer isFitContent
		ifTrue: [ ^ self ].


	anEvent consumed: true.
	editorModel scrollBy: anEvent vector y.
	self requestLayout.
	self invalidate
]

{ #category : #'as yet unclassified' }
GtTextEditorElement >> paintMeAndChildrenOn: aCompositorPainter offset: anOffset [
	| drawMethod viewportOffset textureExtent |
	super paintMeAndChildrenOn: aCompositorPainter offset: anOffset.

	drawMethod := FFIBackend current
			loadSymbol: #editor_draw
			module: GtTextEditorLibrary uniqueInstance libraryName.

	viewportOffset := 0 @ (viewportTop ifNil: [ 0.0 ]).
	
	NonInteractiveTranscript stdout
		nextPutAll: 'viewport offset: ';
		nextPutAll: viewportOffset asString;
		cr.
	
	textureExtent := self extent - viewportOffset.
	
	NonInteractiveTranscript stdout
		nextPutAll: 'texture extent: ';
		nextPutAll: textureExtent asString;
		cr.

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
GtTextEditorElement >> text: aString [
	editorModel := GtTextEditorModel newString: aString
]
