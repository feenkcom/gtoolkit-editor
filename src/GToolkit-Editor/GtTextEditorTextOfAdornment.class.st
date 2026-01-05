Class {
	#name : 'GtTextEditorTextOfAdornment',
	#superclass : 'Object',
	#instVars : [
		'editorElement',
		'adornmentId',
		'addedAttributes'
	],
	#category : 'GToolkit-Editor-FFI-Text',
	#package : 'GToolkit-Editor',
	#tag : 'FFI-Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorTextOfAdornment >> attributes: aCollection [
	aCollection do: [ :eachAttribute |
		editorElement
			addAttribute: eachAttribute
			overAdornment: adornmentId ].
	addedAttributes addAll: aCollection
]

{ #category : 'as yet unclassified' }
GtTextEditorTextOfAdornment >> clearAttributes: aFullBlockClosure [
	| attributesToRemove |
	attributesToRemove := addedAttributes select: aFullBlockClosure.
	
]

{ #category : 'as yet unclassified' }
GtTextEditorTextOfAdornment >> initialize [
	super initialize.
	
	addedAttributes := OrderedCollection new
]

{ #category : 'initialization' }
GtTextEditorTextOfAdornment >> setEditorElement: anEditorElement adornmentId: anAdornmentId [
	editorElement := anEditorElement.
	adornmentId := anAdornmentId
]
