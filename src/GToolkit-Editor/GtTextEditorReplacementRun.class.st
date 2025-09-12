Class {
	#name : #GtTextEditorReplacementRun,
	#superclass : #Object,
	#instVars : [
		'attribute',
		'start',
		'end'
	],
	#category : #'GToolkit-Editor-Model'
}

{ #category : #accessing }
GtTextEditorReplacementRun >> attribute [
	^ attribute
]

{ #category : #accessing }
GtTextEditorReplacementRun >> attribute: anObject [
	attribute := anObject
]

{ #category : #accessing }
GtTextEditorReplacementRun >> end [
	^ end
]

{ #category : #accessing }
GtTextEditorReplacementRun >> end: anObject [
	end := anObject
]

{ #category : #'as yet unclassified' }
GtTextEditorReplacementRun >> gtDisplayOn: stream [
	super gtDisplayOn: stream.
	
	stream
		space;
		nextPut: $[;
		print: start;
		nextPutAll: '..';
		print: end;
		nextPut: $)
]

{ #category : #accessing }
GtTextEditorReplacementRun >> start [
	^ start
]

{ #category : #accessing }
GtTextEditorReplacementRun >> start: anObject [
	start := anObject
]
