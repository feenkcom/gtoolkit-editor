Class {
	#name : 'GtTextEditorTextToStyleIterator',
	#superclass : 'BlTextIterator',
	#instVars : [
		'text',
		'start',
		'stop'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'instance creation' }
GtTextEditorTextToStyleIterator class >> text: aText from: aStartIndex to: anEndIndex [
	
	^ self new
		text: aText from: aStartIndex to: anEndIndex;
		yourself
]

{ #category : 'iterator - accessing' }
GtTextEditorTextToStyleIterator >> attributes [
	^ Array
		streamContents: [ :aStream | 
			text attributesFinder
				findAttributesSuchThat: [ :anAttribute | true ]
				indicesDo: [ :eachStart :eachStop :eachAttribute | 
					((start to: stop) intersection: (eachStart to: eachStop))
						ifNotEmpty: [ aStream nextPut: eachAttribute ] ] ]
]

{ #category : 'accessing' }
GtTextEditorTextToStyleIterator >> text: aText from: aStartIndex to: anEndIndex [
	start := aStartIndex.
	stop := anEndIndex.
	text := aText
]
