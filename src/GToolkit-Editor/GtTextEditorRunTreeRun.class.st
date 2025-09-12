Class {
	#name : #GtTextEditorRunTreeRun,
	#superclass : #Object,
	#instVars : [
		'start',
		'end'
	],
	#category : #'GToolkit-Editor-Model'
}

{ #category : #accessing }
GtTextEditorRunTreeRun >> end [
	^ end
]

{ #category : #accessing }
GtTextEditorRunTreeRun >> end: anObject [
	end := anObject
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTreeRun >> gtDisplayOn: stream [
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
GtTextEditorRunTreeRun >> start [
	^ start
]

{ #category : #accessing }
GtTextEditorRunTreeRun >> start: anObject [
	start := anObject
]
