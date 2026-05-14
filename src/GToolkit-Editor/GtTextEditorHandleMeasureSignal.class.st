Class {
	#name : 'GtTextEditorHandleMeasureSignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'width',
		'top',
		'height'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'as yet unclassified' }
GtTextEditorHandleMeasureSignal >> gtInfoFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Info';
		priority: 1;
		items: [ {'Width' -> self width . 'Height' -> self height. 'Top' -> self top} ];
		column: 'Name' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ]
]

{ #category : 'accessing' }
GtTextEditorHandleMeasureSignal >> height [
	^ height
]

{ #category : 'as yet unclassified' }
GtTextEditorHandleMeasureSignal >> height: aHeightOrNil [
	height := aHeightOrNil
]

{ #category : 'as yet unclassified' }
GtTextEditorHandleMeasureSignal >> printOneLineContentsOn: aStream [
	aStream nextPutAll: 'Measure width: '.
	aStream print: width rounded.
	aStream nextPutAll: ' height: '.
	aStream print: (height ifNotNil: [ :aNumber | aNumber rounded ]).
	aStream nextPutAll: ' top: '.
	aStream print: (top ifNotNil: [ :aNumber | aNumber rounded ]).
]

{ #category : 'accessing' }
GtTextEditorHandleMeasureSignal >> top [
	^ top
]

{ #category : 'as yet unclassified' }
GtTextEditorHandleMeasureSignal >> top: aTopOrNil [
	top := aTopOrNil
]

{ #category : 'accessing' }
GtTextEditorHandleMeasureSignal >> width [
	^ width
]

{ #category : 'as yet unclassified' }
GtTextEditorHandleMeasureSignal >> width: aWidth [
	width := aWidth
]
