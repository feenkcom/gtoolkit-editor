Class {
	#name : 'GtTextEditorTextToStyle',
	#superclass : 'BlText',
	#instVars : [
		'theme',
		'externalText'
	],
	#category : 'GToolkit-Editor-Model',
	#package : 'GToolkit-Editor',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> asGtTextEditorTextForTheme: aTheme during: aBlock [
	^ aBlock value: externalText
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> attributes: anAttributesCollection from: aFromIndex to: aToIndex [
	anAttributesCollection
		ifEmpty: [ ^ self ].
		
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
GtTextEditorTextToStyle >> generation [
	^ self
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> nextGeneration [
	^ self
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> setExternalText: anExternalText theme: aTheme [
	externalText := anExternalText.
	theme := aTheme
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> unstyle [
	^ self
]

{ #category : 'as yet unclassified' }
GtTextEditorTextToStyle >> unstyle: aFromIndex to: aToIndex [
	^ self
]
