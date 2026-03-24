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

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> documentId [
	^ documentId
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> generation [
	^ self documentId
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
