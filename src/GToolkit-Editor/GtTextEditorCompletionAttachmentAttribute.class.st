Class {
	#name : 'GtTextEditorCompletionAttachmentAttribute',
	#superclass : 'BrTextAdornmentAttribute',
	#instVars : [
		'completionElement'
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
GtTextEditorCompletionAttachmentAttribute >> completionElement [
	^ completionElement
]

{ #category : 'accessing' }
GtTextEditorCompletionAttachmentAttribute >> completionElement: anObject [
	completionElement := anObject
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
		withoutGainFocusOnShow;
		withoutHandle;
		withoutMouseEventHandler;
		withContainerAreaBuilders: {BlSteppedLayoutAreaBuilder dropdownBottomRight.
				BlSteppedLayoutAreaBuilder dropdownUpRight.
				BlSteppedLayoutAreaBuilder dropdownBottomLeft.
				BlSteppedLayoutAreaBuilder dropdownUpLeft.};
		stencil: [ :aBrMenuInitialContext | BrMenuExplicit new stencil: [ completionElement removeFromParent ] ] "relocator: BrEditorSearchTextPopoverContainerRelocator new;"
]
