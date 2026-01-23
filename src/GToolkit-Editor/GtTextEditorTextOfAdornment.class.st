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
		| attributeTag |
		
		attributeTag := (editorElement
			addAttribute: eachAttribute
			overAdornment: adornmentId).
			
		addedAttributes add: (attributeTag -> eachAttribute) ].
]

{ #category : 'as yet unclassified' }
GtTextEditorTextOfAdornment >> clearAttributes: aFullBlockClosure [
	addedAttributes
		select: [ :eachAssociation | aFullBlockClosure value: eachAssociation value ]
		thenDo: [ :eachAssociation | "editorElement removeAttribute: eachAttribute overAdornment: adornmentId" ]
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
