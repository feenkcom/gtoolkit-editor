Class {
	#name : #GtTextEditorMetrics,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorMetrics class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorMetrics class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void editor_metrics_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorMetrics >> gtParagraphsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Paragraphs';
		priority: 5;
		items: [ self paragraphs ];
		column: 'Range' text: [ :each | each range ]
]

{ #category : #'as yet unclassified' }
GtTextEditorMetrics >> paragraphs [
	^ GtTextEditorParagraphs
		fromNativeHandle: self primGetParagraphs
]

{ #category : #'as yet unclassified' }
GtTextEditorMetrics >> primGetParagraphs [
	^ self ffiCall: #(void* editor_metrics_clone_paragraphs(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorMetrics >> visualLineAtByteOffset: byteOffset [
	^ (self paragraphs paragraphAtByteOffset: byteOffset)
		ifNotNil: [ :paragraph | 
			(paragraph chunkAtByteOffset: byteOffset)
				ifNotNil: [ :chunk | chunk visualLineAtByteOffset: byteOffset ] ]
]
