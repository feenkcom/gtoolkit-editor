Class {
	#name : 'GtTextEditorParagraph',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Model',
	#package : 'GToolkit-Editor',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
GtTextEditorParagraph class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void paragraph_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> amountOfChunks [
	^ self primGetAmountOfChunks
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> chunkAtByteOffset: byteOffset [
	| chunk |

	chunk := self primGetChunkAtByteOffset: byteOffset.
	chunk isNull
		ifTrue: [ ^ nil ].

	^ GtTextEditorParagraphChunk fromNativeHandle: chunk
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> chunkAtIndex: anIndex [
	| chunk |

	chunk := self primGetChunkAtIndex: anIndex - 1.
	chunk isNull
		ifTrue: [ ^ nil ].

	^ GtTextEditorParagraphChunk fromNativeHandle: chunk
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> chunks [
	^ Array
		streamContents: [ :s | 1 to: self amountOfChunks do: [ :i | s nextPut: (self chunkAtIndex: i) ] ]
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> end [
	^ self primEnd
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> gtChunksFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Chunks';
		priority: 6;
		items: [ self chunks ];
		column: 'Range' text: [ :each | each range ]
]

{ #category : 'views' }
GtTextEditorParagraph >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 5;
		items: [ {'Range' -> self range} ];
		column: 'Property' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ];
		send: [ :each | each value ]
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> primEnd [
	^ self ffiCall: #(size_t paragraph_end(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> primGetAmountOfChunks [
	^ self ffiCall: #(size_t paragraph_amount_of_chunks(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> primGetChunkAtByteOffset: byteOffset [
	^ self ffiCall: #(void* paragraph_get_metrics_at_offset(self, size_t byteOffset))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> primGetChunkAtIndex: anIndex [
	^ self ffiCall: #(void* paragraph_get_chunk_at_index(self, size_t anIndex))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> primLength [
	^ self ffiCall: #(size_t paragraphs_len(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> primStart [
	^ self ffiCall: #(size_t paragraph_start(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> range [
	^ GtTextEditorTextRange start: self start end: self end
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> size [
	^ self primLength
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraph >> start [
	^ self primStart
]
