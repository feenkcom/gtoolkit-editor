Class {
	#name : 'GtTextEditorStylerAsyncStrategy',
	#superclass : 'BrTextStylerStrategy',
	#instVars : [
		'editorStylingFuture'
	],
	#category : 'GToolkit-Editor-Styler',
	#package : 'GToolkit-Editor',
	#tag : 'Styler'
}

{ #category : 'initialization' }
GtTextEditorStylerAsyncStrategy >> initialize [
	super initialize.

	editorStylingFuture := BrAsyncElementFuture new
		cancelSoft;
		executionConfiguration: (AsyncFutureExecutionConfiguration new customGroup: #TextStyler);
		whenSuccess: [ :anEditorElement :aStyledEvent | anEditorElement dispatchEvent: aStyledEvent ]
]

{ #category : 'styling' }
GtTextEditorStylerAsyncStrategy >> styleText: anUnstyledText inEditorElement: aBrEditorElement thenDo: aBlock [
	| aTextStylingFuture aTextStyler|
	
	aTextStyler := aBrEditorElement styler.
	aTextStyler affectsText
		ifFalse: [ ^ self ].

	aTextStylingFuture := [
		| aStyledText |

		aStyledText := self
			doStyleText: anUnstyledText with: aTextStyler
			afterDo: aBlock.

		(BrTextStyledEvent new
			text: aStyledText;
			afterAction: aBlock;
			editorElement: aBrEditorElement) ] asAsyncFuture.

	editorStylingFuture
		element: aBrEditorElement;
		future: aTextStylingFuture
]

{ #category : 'styling' }
GtTextEditorStylerAsyncStrategy >> styleTextInEditorElement: aBrEditorElement thenDo: aBlock [
	| aTextStylingFuture aTextStyler|
	
	aTextStyler := aBrEditorElement styler.
	aTextStyler affectsText
		ifFalse: [ ^ self ].

	aTextStylingFuture := [
		| anUnstyledText aStyledText |
		
		anUnstyledText := aBrEditorElement unstyledText.

		aStyledText := self
			doStyleText: anUnstyledText with: aTextStyler
			afterDo: aBlock.

		(BrTextStyledEvent new
			text: aStyledText;
			afterAction: aBlock;
			editorElement: aBrEditorElement) ] asAsyncFuture.

	editorStylingFuture
		element: aBrEditorElement;
		future: aTextStylingFuture
]
