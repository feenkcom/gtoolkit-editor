Class {
	#name : 'GtTextEditorDebugElement',
	#superclass : 'BrHorizontalPane',
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'visualLine',
		'editorElement',
		'editorElementContainer',
		'debugInfoContainer',
		'mousePointLabel',
		'mouseByteOffsetLabel',
		'mouseTextAroundEditor'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'as yet unclassified' }
GtTextEditorDebugElement >> drawMeAndChildrenOnSpartaCanvas: aCanvas [
	super drawMeAndChildrenOnSpartaCanvas: aCanvas.

	self drawVisualLineOnSpartaCanvas: aCanvas
]

{ #category : 'as yet unclassified' }
GtTextEditorDebugElement >> drawOnSpartaCanvas: aCanvas [
	super drawOnSpartaCanvas: aCanvas.
	
	visualLine ifNotNil: [ :aLine |
		aCanvas fill
			path: aLine bounds;
			paint: (Color gray alpha: 0.4);
			draw ].
]

{ #category : 'as yet unclassified' }
GtTextEditorDebugElement >> drawVisualLineOnSpartaCanvas: aCanvas [
	
	"visualLine ifNotNil: [ :aLine |
		aCanvas fill
			path: aLine bounds;
			paint: (Color gray alpha: 0.2);
			draw ]."
]

{ #category : 'accessing' }
GtTextEditorDebugElement >> editorElement [
	^ editorElement
]

{ #category : 'accessing' }
GtTextEditorDebugElement >> editorElement: anObject [
	editorElement := anObject.
	editorElementContainer removeChildren.
	editorElementContainer addChild: editorElement.

	editorElementContainer
		constraintsDo: [ :c |
			c horizontal resizer: editorElement constraints horizontal resizer.
			c vertical resizer: editorElement constraints vertical resizer ]
]

{ #category : 'as yet unclassified' }
GtTextEditorDebugElement >> initialize [
	super initialize.

	self matchParent.

	editorElementContainer := BrFrame new vMatchParent.
	editorElementContainer
		addEventFilterOn: BlMouseMoveEvent
		do: [ :anEvent | self onMouseMove: anEvent ].

	debugInfoContainer := BrVerticalPane new
		matchParent;
		padding: (BlInsets left: 12).

	mousePointLabel := BrLabel new
			aptitude: (BrGlamorousLabelAptitude new fontSize: 16);
			text: ''.

	mouseByteOffsetLabel := BrLabel new
			aptitude: (BrGlamorousLabelAptitude new fontSize: 16);
			text: ''.

	mouseTextAroundEditor := BrEditor new
			aptitude: (BrGlamorousRegularEditorAptitude new fontSize: 20);
			hMatchParent;
			vFitContent;
			yourself.

	debugInfoContainer
		addChild: (self newSectionLabel: 'Mouse location:');
		addChild: mousePointLabel;
		addChild: (self newSectionLabel: 'Byte offset:');
		addChild: mouseByteOffsetLabel;
		addChild: (self newSectionLabel: 'Text around byte offset:');
		addChild: mouseTextAroundEditor.

	self
		addChildren: {editorElementContainer.
				debugInfoContainer}
]

{ #category : 'as yet unclassified' }
GtTextEditorDebugElement >> newSectionLabel: aName [
	^ BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			margin: (BlInsets top: 12);
			text: aName
]

{ #category : 'as yet unclassified' }
GtTextEditorDebugElement >> onMouseMove: anEvent [
	| editorClone metrics mousePosition mouseByteOffset mouseTextAround |
	editorClone := editorElement editorModel editorClone.
	metrics := editorClone metrics.

	mousePosition := anEvent localPosition.
	mouseByteOffset := editorClone byteOffsetAt: mousePosition.
	mouseTextAround := mouseByteOffset ifNotNil: [ :anOffset |
		editorClone
			textAroundByteOffset: anOffset
			amountOfChars: 10
			during: [ :textAround |
				| rope stringRope cursorIndex|
				
				rope := '' asRopedText.
				textAround lineStartOffset > 0
					ifTrue: [
						rope append: ('...' asRopedText fontSize: 14; foreground: Color gray) ].
				
				cursorIndex := textAround byteOffsetCharIndex.
				stringRope := textAround string asRopedText.
				stringRope insertString: '|' at: cursorIndex.
				
				(stringRope from: cursorIndex + 1 to: cursorIndex + 1)
					bold;
					foreground: Color red.
					
				rope append: stringRope.
					
				textAround lineEndOffset > 0
					ifTrue: [
						rope append: ('...' asRopedText fontSize: 14; foreground: Color gray) ].
				rope ] ].

	visualLine := metrics visualLineAtPoint: mousePosition.
	mousePointLabel text: mousePosition printString.
	mouseByteOffsetLabel text: mouseByteOffset printString.
	mouseTextAroundEditor text: mouseTextAround.

	self invalidate
]

{ #category : 'as yet unclassified' }
GtTextEditorDebugElement >> paintMeAndChildrenOn: aCompositorPainter offset: anOffset [
	| aCanvas |
	super paintMeAndChildrenOn: aCompositorPainter offset: anOffset.

	aCanvas := aCompositorPainter canvas.
	aCanvas transform
		by: [ :t | t translateBy: anOffset ]
		during: [ self drawVisualLineOnSpartaCanvas: aCanvas ] 
]
