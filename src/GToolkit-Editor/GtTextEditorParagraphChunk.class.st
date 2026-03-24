Class {
	#name : 'GtTextEditorParagraphChunk',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void chunk_metrics_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> amountOfVisualLines [
	^ self primGetAmountOfVisualLines
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> end [
	^ self primEnd
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 5;
		items: [
			{
				'Range' -> self range.
				'Amount of visual lines' -> self amountOfVisualLines.
				'Top' -> self top
			} ];
		column: 'Property' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ];
		send: [ :each | each value ]
]

{ #category : 'views' }
GtTextEditorParagraphChunk >> gtVisualLinesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Lines';
		priority: 6;
		items: [ self visualLines ];
		column: 'Range' text: [ :each | each range ]
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> primEnd [
	^ self ffiCall: #(size_t chunk_metrics_end(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> primGetAmountOfVisualLines [
	^ self ffiCall: #(size_t chunk_metrics_amount_of_visual_lines(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> primGetTop [
	^ self ffiCall: #(float64 chunk_metrics_top(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> primGetVisualLineAtByteOffset: byteOffset [
	^ self ffiCall: #(void* chunk_metrics_get_visual_line_at_offset(self, size_t byteOffset))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> primGetVisualLineAtIndex: anIndex [
	^ self ffiCall: #(void* chunk_metrics_get_visual_line_at(self, size_t anIndex))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> primStart [
	^ self ffiCall: #(size_t chunk_metrics_start(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> range [
	^ GtTextEditorTextRange start: self start end: self end
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> start [
	^ self primStart
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> top [
	^ self primGetTop
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> visualLineAt: index [
	| line |

	line := self primGetVisualLineAtIndex: index - 1.
	line isNull
		ifTrue: [ ^ nil ].

	^ GtTextEditorParagraphVisualLine fromNativeHandle: line
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> visualLineAtByteOffset: byteOffset [
	| line |

	line := self primGetVisualLineAtByteOffset: byteOffset.
	line isNull
		ifTrue: [ ^ nil ].

	^ GtTextEditorParagraphVisualLine fromNativeHandle: line
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphChunk >> visualLines [
	^ Array
		streamContents: [ :s | 1 to: self amountOfVisualLines do: [ :i | s nextPut: (self visualLineAt: i) ] ]
]
