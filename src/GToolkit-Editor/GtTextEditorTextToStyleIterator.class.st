Class {
	#name : 'GtTextEditorTextToStyleIterator',
	#superclass : 'BlTextIterator',
	#instVars : [
		'text',
		'start',
		'position',
		'end',
		'attributes'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'instance creation' }
GtTextEditorTextToStyleIterator class >> text: aText attributes: allAttributes from: aStartIndex to: anEndIndex [
	
	^ self new
		text: aText attributes: allAttributes from: aStartIndex to: anEndIndex;
		yourself
]

{ #category : 'iterator - attributes' }
GtTextEditorTextToStyleIterator >> allAttributes [
	"Return a collection of rope attributes at a current range without duplicates"

	<return: #Collection of: #BlTextAttribute>
	self hasNext ifFalse: [ ^ #() ].

	^ Array
		streamContents: [ :aStream | 
			text attributesFinder
				findAttributesSuchThat: [ :anAttribute | true ]
				indicesDo: [ :eachStart :eachStop :eachAttribute | 
					((start to: end) intersection: (eachStart to: eachStop))
						ifNotEmpty: [ aStream nextPut: eachAttribute ] ] ]
]

{ #category : 'asserting' }
GtTextEditorTextToStyleIterator >> assertInvariant [
	"I am a position invariant; I make sure that iterator operations do not go out of bounds"

	(position >= start)
		ifFalse: [ self error: 'Position must always be greater or equal than start' ].

	(position <= end)
		ifFalse: [ self error: 'Position must always be less or equal than end' ].
]

{ #category : 'iterator - attributes' }
GtTextEditorTextToStyleIterator >> attributes [
	"Return a collection of rope attributes at a current position without duplicates"

	<return: #Collection of: #BlTextAttribute>
	self hasNext ifFalse: [ ^ #() ].

	^ Array
		streamContents: [ :aStream | 
			attributes
				do: [ :eachAssociation | 
					| eachStart eachEnd eachAttribute |
					eachStart := eachAssociation value first.
					eachEnd := eachAssociation value last.
					eachAttribute := eachAssociation key.
					((eachStart to: eachEnd) includes: position)
						ifTrue: [ aStream nextPut: eachAttribute ] ] ]
]

{ #category : 'asserting' }
GtTextEditorTextToStyleIterator >> errorReachedTheEnd [
	self error: 'Reached the end of the rope iterator!'
]

{ #category : 'gt - extensions' }
GtTextEditorTextToStyleIterator >> gtAttributesFor: aView [
	<gtView>
	attributes ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Attributes';
		items: [ attributes ifNil: [ #() ] ];
		column: 'Index'
			text: [ :each :index | index ]
			width: 60;
		column: 'Position'
			text: [ :eachAssociation | 
				| eachText includesPosition |
				includesPosition := false.
				eachText := eachAssociation value size = 1
						ifTrue: [ eachAssociation value first = position ifTrue: [ includesPosition := true ].
							eachAssociation value first ]
						ifFalse: [ ((eachAssociation value first to: eachAssociation value last)
								includes: position) ifTrue: [ includesPosition := true ].
							'{1}-{2}'
								format: {eachAssociation value first.
										eachAssociation value last} ].
				includesPosition ifTrue: [ eachText asRopedText bold ] ifFalse: [ eachText ] ];
		column: 'Attribute'
			text: [ :each | each key ]
			weight: 5;
		send: #key
]

{ #category : 'iterator - testing' }
GtTextEditorTextToStyleIterator >> hasNext [
	<return: #Boolean>
	^ position <= end
]

{ #category : 'iterator - enumeration' }
GtTextEditorTextToStyleIterator >> next [
	"Return an item (character) at current position and move one to the right"

	<return: #Character or: #Object>
	self hasNext ifFalse: [ self errorReachedTheEnd ].

	^ position := position + 1
]

{ #category : 'iterator - accessing' }
GtTextEditorTextToStyleIterator >> position [
	<return: #Number>

	^ position
]

{ #category : 'accessing' }
GtTextEditorTextToStyleIterator >> text: aText attributes: allAttributes from: aStart to: anEnd [
	(aText isNotEmpty and: [ aStart < 0 or: [ anEnd > aText size ] ])
		ifTrue: [ self error: 'Iterator interval out of bounds!' ].
	(aText isEmpty and: [ aStart ~= 0 or: [ anEnd ~= 0 ] ])
		ifTrue: [ self error: 'Iterator interval out of bounds!' ].

	text := aText.
	attributes := allAttributes
			sorted: [ :a :b | 
				a value first < b value first
					or: [ a value first = b value first and: [ a value last < b value last ] ] ].
	start := aStart min: anEnd.
	end := anEnd max: aStart.
	position := aStart
]
