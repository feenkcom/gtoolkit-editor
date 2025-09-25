Class {
	#name : #GtTextEditorText,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorText class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorText class >> primFromString: aStringBox [
	^ self ffiCall: #(void* text_from_string(void* aStringBox))
]

{ #category : #'as yet unclassified' }
GtTextEditorText class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void text_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorText class >> string: aString [
	^ self ffiLibrary
		newString: aString
		during: [ :aStringBox | self fromNativeHandle: (self primFromString: aStringBox) ]
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> attribute: aTextAttribute from: aStart to: anEnd [
	aTextAttribute asAttributeDuring: [ :attr |
		self
			primAddAttribute: attr
			start: aStart - 1
			end: anEnd ]
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> chunksToMeasure: chunkSize [
	^ GtTextEditorChunksToMeasure fromNativeHandle: (self primChunksToMeasure: chunkSize)
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> gtChunksToMeasureFor: aView [
	<gtView>
	| chunkSize |
	
	chunkSize := 10.
	
	^ aView columnedList
		title: 'Chunks to measure';
		priority: 8;
		items: [ (self chunksToMeasure: chunkSize) asArray ];
		column: 'Range' text: [ :each | each range ] 
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> gtTextFor: aView [
	<gtView>
	^ aView explicit
		title: 'Text';
		priority: 3;
		stencil: [
			GtTextEditorElement new
				matchParent;
				text: self ];
		actionUpdateButton
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> gtTextWithReplacementsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Text and replacements';
		priority: 7;
		items: [ self textWithReplacements asArray ];
		column: 'Kind' text: [ :each | each kindName ];
		column: 'Range' text: [ :each | each range ] 
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> insertString: aString at: anIndex [
	self ffiLibrary newString: aString during: [ :aStringBox |
		| offset |
		offset := anIndex min: self size max: 0.
		self
			primInsertString: aStringBox
			offset:offset ]
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> primAddAttribute: anAttribute start: aStart end: anEnd [
	^ self ffiCall: #(void text_add_attribute(
		self,
		void* anAttribute,
		size_t aStart,
		size_t anEnd))
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> primChunksToMeasure: aChunkSize [
	^ self ffiCall: #(void* text_chunks_to_measure(self, size_t aChunkSize))
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> primInsertString: aStringBox offset: anOffset [
	^ self ffiCall: #(void text_insert_str(
		self,
		void* aStringBox,
		size_t anOffset))
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> primLen [
	^ self ffiCall: #(size_t text_len(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> primTextWithReplacements [
	^ self ffiCall: #(void* text_with_replacements(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> size [
	^ self primLen
]

{ #category : #'as yet unclassified' }
GtTextEditorText >> textWithReplacements [
	^ GtTextEditorTextWithReplacements fromNativeHandle: self primTextWithReplacements
]
