"
Regression examples for the bug where a collapsed-then-re-expanded toggle adornment stayed clickable at its old, now-stale bounds. A collapsed cached adornment child must become BlVisibility gone (not just be dropped from tracking), stop receiving clicks, and become visible again on re-expand without recreating the cached child element.
"
Class {
	#name : 'GtTextEditorElementAdornmentVisibilityExamples',
	#superclass : 'Object',
	#instVars : [
		'expanderAttribute'
	],
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples' }
GtTextEditorElementAdornmentVisibilityExamples >> elementWithCollapsedToggleAdornment [
	<gtExample>
	| anElement aText aScripter |
	GtTextEditorLibrary canRunExamples ifFalse: [ ^ nil ].
	
	aText := 'Text with expander attribute.' asRopedText
			glamorousRegularFontAndSize.
	(aText from: 18 to: 18)
		expanded: false
		adornment: [ :aTBrTextEditorTextualPiece :anEditorElement | 
			BlElement new
				id: #expanded;
				size: 100 @ 200;
				background: (Color blue alpha: 0.5) ]
		id: #expander.

	anElement := GtTextEditorElement new.
	anElement matchParent.
	anElement text: aText.
	aScripter := BlScripter new element: anElement.
	self scripter: aScripter waitEditorRendered: anElement.

	^ aScripter
]

{ #category : 'examples' }
GtTextEditorElementAdornmentVisibilityExamples >> elementWithCollapsedToggleAdornment2_expand [
	"See https://github.com/feenkcom/gtoolkit-editor/issues/26"

	<gtExample>
	| aScripter |
	GtTextEditorLibrary canRunExamples ifFalse: [ ^ nil ].
	
	aScripter := self elementWithCollapsedToggleAdornment.

	aScripter click
		label: 'Expand expander';
		// #expander;
		play.
	aScripter assert
		label: 'Assert expanded element exists';
		exists;
		// #expanded;
		play.

	^ aScripter
]

{ #category : 'examples' }
GtTextEditorElementAdornmentVisibilityExamples >> elementWithCollapsedToggleAdornment2_expand_collapse [
	<gtExample>
	| aScripter anElement |
	GtTextEditorLibrary canRunExamples ifFalse: [ ^ nil ].
	
	aScripter := self elementWithCollapsedToggleAdornment2_expand.
	anElement := aScripter element.

	aScripter click
		label: 'Collapse expander';
		// #expander;
		play.

	aScripter assert
		label: 'Assert expanded element exists';
		notExists;
		// #expanded;
		play.

	^ aScripter
]

{ #category : 'examples' }
GtTextEditorElementAdornmentVisibilityExamples >> scripter: aScripter waitEditorRendered: anElement [
	| aSemaphore |
	aSemaphore := Semaphore new.
	anElement privateRequestEditorAction: [ :aMessage | aSemaphore signal ].

	aScripter wait
		forSemaphore: aSemaphore pulseDuring: 5 seconds;
		play.

	self assert: aSemaphore isSignaled
]
