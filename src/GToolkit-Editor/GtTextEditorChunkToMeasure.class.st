Class {
	#name : #GtTextEditorChunkToMeasure,
	#superclass : #GtBoxerValueBox,
	#instVars : [
		'attribute'
	],
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorChunkToMeasure class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorChunkToMeasure class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void chunk_to_measure_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorChunkToMeasure >> end [
	^ self primGetEnd
]

{ #category : #'as yet unclassified' }
GtTextEditorChunkToMeasure >> primGetEnd [
	^ self ffiCall: #(size_t chunk_to_measure_end(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorChunkToMeasure >> primGetStart [
	^ self ffiCall: #(size_t chunk_to_measure_start(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorChunkToMeasure >> range [
	^ GtTextEditorTextRange start: self start end: self end
]

{ #category : #'as yet unclassified' }
GtTextEditorChunkToMeasure >> start [
	^ self primGetStart
]
