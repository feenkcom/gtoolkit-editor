Class {
	#name : 'GtTextEditorRequestLayoutSignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'sourceElement'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'printing' }
GtTextEditorRequestLayoutSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: 'Request layout: '.
	sourceElement gtDisplayOn: stream
]

{ #category : 'accessing' }
GtTextEditorRequestLayoutSignal >> sourceElement [
	^ sourceElement
]

{ #category : 'accessing' }
GtTextEditorRequestLayoutSignal >> sourceElement: anObject [
	sourceElement := anObject
]
