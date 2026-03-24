Class {
	#name : 'GtTextEditorTextRange',
	#superclass : 'Object',
	#instVars : [
		'start',
		'end'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorTextRange class >> start: aStart end: anEnd [
	^ self new start: aStart end: anEnd
]

{ #category : 'as yet unclassified' }
GtTextEditorTextRange >> end [
	^ end
]

{ #category : 'as yet unclassified' }
GtTextEditorTextRange >> gtDisplayOn: stream [
	stream
		nextPut: $[;
		print: start;
		nextPutAll: ' .. ';
		print: end;
		nextPut: $)
]

{ #category : 'as yet unclassified' }
GtTextEditorTextRange >> start [
	^ start
]

{ #category : 'as yet unclassified' }
GtTextEditorTextRange >> start: aStart end: anEnd [
	start := aStart.
	end := anEnd
]
