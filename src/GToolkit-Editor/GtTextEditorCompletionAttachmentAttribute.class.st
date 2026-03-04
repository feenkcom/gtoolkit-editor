Class {
	#name : 'GtTextEditorCompletionAttachmentAttribute',
	#superclass : 'BrTextAdornmentAttribute',
	#instVars : [
		'completionResult'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'accessing' }
GtTextEditorCompletionAttachmentAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	| element |
	element := BlElement new.
	element size: 5 @ 16.
	element background: Color red.
	element addAptitude: self newAptitude.
	element when: BlElementAddedToSceneGraphEvent do: [ :anEvent |
		anEvent currentTarget dispatchEvent: (BrDropdownShowWish new).
	].
	element when: BlElementRemovedFromSceneGraphEvent do: [ :anEvent |
		anEvent currentTarget dispatchEvent: (BrDropdownHideWish new).
	].
	^ element
]

{ #category : 'accessing' }
GtTextEditorCompletionAttachmentAttribute >> completionResult [
	^ completionResult
]

{ #category : 'accessing' }
GtTextEditorCompletionAttachmentAttribute >> completionResult: anObject [
	completionResult := anObject
]

{ #category : 'as yet unclassified' }
GtTextEditorCompletionAttachmentAttribute >> gtExternalTextConfigureAppendingAttribute: anAttribute [
	super gtExternalTextConfigureAppendingAttribute: anAttribute.
	
	anAttribute beExactWidth: 5.
	anAttribute beExactHeight: 16.
]

{ #category : 'initialization' }
GtTextEditorCompletionAttachmentAttribute >> initialize [
	super initialize.
	self beAppend.
	self beNotOverwritableByStyler.
	self placeholderAlignment: #alignBottom.
	self shouldPropagate: false
]

{ #category : 'accessing' }
GtTextEditorCompletionAttachmentAttribute >> newAptitude [
	^ BrGlamorousWithExplicitDropdownAptitude new
		withoutHandle;
		withoutMouseEventHandler;
		stencil: [ :aBrMenuInitialContext | BrMenuExplicit new stencil: [ self newCompletionList ] ]	"relocator: BrEditorSearchTextPopoverContainerRelocator new;"
]

{ #category : 'accessing' }
GtTextEditorCompletionAttachmentAttribute >> newCompletionList [
	^ BrSimpleList new
		exact: 200@200;
		itemStencil: [ BrLabel new aptitude: BrGlamorousLabelAptitude ];
		itemDataBinder: [ :eachLabel :eachItem | eachLabel text: eachItem label ];
		stream: completionResult asAsyncStream
]
