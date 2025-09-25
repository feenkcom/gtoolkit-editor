Class {
	#name : #GtTextEditorChunksToMeasure,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorChunksToMeasure class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorChunksToMeasure class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void chunks_to_measure_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorChunksToMeasure >> asArray [
	^ Array streamContents: [ :s |
		| next |
		[ next := self nextOrNil ]
			whileNotNil: [
				s nextPut: next ] ]
]

{ #category : #'as yet unclassified' }
GtTextEditorChunksToMeasure >> nextOrNil [
	| next |
	
	next := self primNext.
	next isNull ifTrue: [ ^ nil ].
	
	^ GtTextEditorChunkToMeasure
		fromNativeHandle: next
]

{ #category : #'as yet unclassified' }
GtTextEditorChunksToMeasure >> primNext [
	^ self ffiCall: #(void* chunks_to_measure_next(self))
]
