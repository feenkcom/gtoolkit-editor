Class {
	#name : 'GtTextEditorTextToStyleAttributesFinder',
	#superclass : 'Object',
	#traits : 'TBlTextAttributesFinder',
	#classTraits : 'TBlTextAttributesFinder classTrait',
	#instVars : [
		'attributes'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'api - initialization' }
GtTextEditorTextToStyleAttributesFinder >> attributes: allAttributes [
	attributes := allAttributes
			sorted: [ :a :b | 
				a value first < b value first
					or: [ a value first = b value first and: [ a value last < b value last ] ] ]
]

{ #category : 'enumerating' }
GtTextEditorTextToStyleAttributesFinder >> findAttribute: aBlTextAttribute indicesDo: aBlock [
	attributes
		do: [ :association | 
			| start stop value |
			start := association value first.
			stop := association value last.
			value := association key.
			value = aBlTextAttribute
				ifTrue: [ aBlock
						cull: start
						cull: stop
						cull: aBlTextAttribute ] ]
]

{ #category : 'enumerating' }
GtTextEditorTextToStyleAttributesFinder >> findAttributesSuchThat: aFilterBlock indicesDo: anIterationBlock [
	attributes
		do: [ :association | 
			| start stop value |
			start := association value first.
			stop := association value last.
			value := association key.
			(aFilterBlock value: value)
				ifTrue: [ anIterationBlock
						cull: start
						cull: stop
						cull: value ] ].
]

{ #category : 'views' }
GtTextEditorTextToStyleAttributesFinder >> gtAttributesFor: aView [
	<gtView>
	attributes ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Attributes';
		items: [ attributes ifNil: [ #() ] ];
		column: 'Index'
			text: [ :each :index | index ]
			width: 60;
		column: 'Position'
			text: [ :each | 
				each value size = 1
					ifTrue: [ each value first ]
					ifFalse: [ '{1}-{2}'
							format: {each value first.
									each value last} ] ];
		column: 'Attribute'
			text: [ :each | each key ]
			weight: 5;
		send: #key
]
