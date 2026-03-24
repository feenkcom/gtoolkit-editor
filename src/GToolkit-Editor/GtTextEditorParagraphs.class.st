Class {
	#name : 'GtTextEditorParagraphs',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void paragraphs_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs >> asArray [
	| array |

	array := Array new: self size.

	1 to: self size do: [ :i |
		array at: i put: (self at: i) ].
		
	^ array
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider forCollection: self
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs >> at: anIndex [
	^ GtTextEditorParagraph fromNativeHandle: (self primAt: anIndex - 1)
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs >> gtParagraphsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Paragraphs';
		priority: 5;
		items: [ self ];
		column: 'Range' text: [ :each | each range ]
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs >> paragraphAtByteOffset: byteOffset [
	| paragraph |

	paragraph := self primParagraphAtOffset: byteOffset.
	paragraph isNull
		ifTrue: [ ^ nil ].

	^ GtTextEditorParagraph fromNativeHandle: paragraph
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs >> primAt: anIndex [
	^ self ffiCall: #(void* paragraphs_get_clone(self, size_t anIndex))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs >> primLength [
	^ self ffiCall: #(size_t paragraphs_len(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs >> primParagraphAtOffset: aByteOffset [
	^ self ffiCall: #(void* paragraphs_get_at_offset(self, size_t aByteOffset))
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphs >> size [
	^ self primLength
]
