Class {
	#name : 'GtTextEditorTextToStyle',
	#superclass : 'BlText',
	#instVars : [
		'theme',
		'externalText',
		'allAttributes',
		'documentId'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> asGtTextEditorTextForTheme: aTheme during: aBlock [
	^ aBlock value: externalText
]

{ #category : 'converting' }
GtTextEditorTextToStyle >> asString [
	^ externalText asString
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> attributes: anAttributesCollection from: aFromIndex to: aToIndex [
	anAttributesCollection
		ifEmpty: [ ^ self ].
	
	allAttributes addAll: (anAttributesCollection collect: [ :each | each -> (aFromIndex to: aToIndex) ]).
	
	anAttributesCollection do: [ :eachAttribute |
			eachAttribute
				asGtExternalTextAttributeForTheme: theme
				during: [ :externalAttribute |
					externalText
						attribute: externalAttribute
						from: aFromIndex
						to: aToIndex ] ].
]

{ #category : 'text - attributes' }
GtTextEditorTextToStyle >> attributesFinder [
	^ GtTextEditorTextToStyleAttributesFinder new attributes: allAttributes
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> documentId [
	^ documentId
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> generation [
	^ self documentId
]

{ #category : 'gt - extensions' }
GtTextEditorTextToStyle >> gtTextFor: aView [
	<gtView>
	^ aView forward
		title: 'Text';
		priority: 10;
		object: [ externalText ];
		view: #gtTextFor:
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> initialize [
	super initialize.
	
	allAttributes := OrderedCollection new
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> isEmpty [
	^ self size = 0
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> nextGeneration [
	^ self
]

{ #category : 'printing' }
GtTextEditorTextToStyle >> printOn: aStream [
	aStream nextPutAll: externalText asString
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> setExternalText: anExternalText documentId: aDocumentId theme: aTheme [
	externalText := anExternalText.
	documentId := aDocumentId.
	theme := aTheme
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> size [
	^ externalText size
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> unstyle [
	^ self
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> unstyle: aFromIndex to: aToIndex [
	^ self
]
