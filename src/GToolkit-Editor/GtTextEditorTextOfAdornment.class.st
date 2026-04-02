Class {
	#name : 'GtTextEditorTextOfAdornment',
	#superclass : 'Object',
	#instVars : [
		'editorElement',
		'addedAttributes',
		'adornmentTag'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorTextOfAdornment >> attributes: aCollection [
	aCollection do: [ :eachAttribute |
		| attributeTag |
		
		attributeTag := (editorElement
			addAttribute: eachAttribute
			overMarker: adornmentTag).
			
		addedAttributes add: (attributeTag -> eachAttribute) ].
]

{ #category : 'as yet unclassified' }
GtTextEditorTextOfAdornment >> clearAttributes: aFullBlockClosure [
	| attributesToRemove attributesToKeep |
	
	attributesToRemove := OrderedCollection new.
	attributesToKeep := OrderedCollection new.
	
	addedAttributes do: [ :eachAssociation |
		(aFullBlockClosure value: eachAssociation value)
			ifTrue: [ attributesToRemove add: eachAssociation ]
			ifFalse: [ attributesToKeep add: attributesToKeep ] ].
			
	addedAttributes := attributesToKeep.

	attributesToRemove do: [ :eachAssociation |
		editorElement
			removeAttributeTagged: eachAssociation key
			overMarker: adornmentTag ]
]

{ #category : 'as yet unclassified' }
GtTextEditorTextOfAdornment >> initialize [
	super initialize.
	
	addedAttributes := OrderedCollection new
]

{ #category : 'initialization' }
GtTextEditorTextOfAdornment >> setEditorElement: anEditorElement adornmentId: anAdornmentId [
	editorElement := anEditorElement.
	adornmentTag := anAdornmentId
]
