Class {
	#name : 'GtTextEditorMeasureSignal',
	#superclass : 'ContextStackSignal',
	#instVars : [
		'width',
		'top',
		'height'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'as yet unclassified' }
GtTextEditorMeasureSignal >> gtInfoFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Info';
		priority: 1;
		items: [ {'Width' -> self width . 'Height' -> self height. 'Top' -> self top} ];
		column: 'Name' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ]
]

{ #category : 'accessing' }
GtTextEditorMeasureSignal >> height [
	^ height
]

{ #category : 'as yet unclassified' }
GtTextEditorMeasureSignal >> height: aHeightOrNil [
	height := aHeightOrNil
]

{ #category : 'accessing' }
GtTextEditorMeasureSignal >> top [
	^ top
]

{ #category : 'as yet unclassified' }
GtTextEditorMeasureSignal >> top: aTopOrNil [
	top := aTopOrNil
]

{ #category : 'accessing' }
GtTextEditorMeasureSignal >> width [
	^ width
]

{ #category : 'as yet unclassified' }
GtTextEditorMeasureSignal >> width: aWidth [
	width := aWidth
]
