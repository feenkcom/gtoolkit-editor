Class {
	#name : 'GtTextEditorExternalText',
	#superclass : 'GtBoxerValueBox',
	#instVars : [
		'adornments'
	],
	#category : 'GToolkit-Editor-FFI-Text',
	#package : 'GToolkit-Editor',
	#tag : 'FFI-Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorExternalText class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalText class >> fromString: aString [
	^ self ffiLibrary
		newString: aString
		during: [ :aStringBox | self fromNativeHandle: (self primFromString: aStringBox) ]
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalText class >> fromString: aString during: aBlock [
	^ self ffiLibrary
		newString: aString
		during: [ :aStringBox |
			self
				fromNativeHandle: (self primFromString: aStringBox)
				during: aBlock ]
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalText class >> fromText: aBlText theme: aBlTheme during: aBlock [
	^ aBlText
		asGtTextEditorTextForTheme: aBlTheme
		during: aBlock
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalText class >> primFromString: aStringBox [
	^ self ffiCall: #(void* text_from_string(void* aStringBox))
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalText class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void text_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorExternalText >> adornments [
	^ adornments
]

{ #category : 'converting' }
GtTextEditorExternalText >> asGtTextEditorTextForTheme: aTheme during: aBlock [
	^ aBlock value: self
]

{ #category : 'text - attributes' }
GtTextEditorExternalText >> attribute: aTextAttribute from: aStart to: anEnd [
	aTextAttribute isAdornmentAttribute
		ifTrue: [
			adornments
				at: aTextAttribute id
				put: aTextAttribute adornmentAttribute ].

	aTextAttribute asGtExternalTextAttributeDuring: [ :attr |
		self
			primAddAttribute: attr
			start: ((aStart - 1) max: 0)
			end: anEnd ]
]

{ #category : 'accessing' }
GtTextEditorExternalText >> attributes [
	^ GtTextEditorRunTree fromNativeHandle: self primCloneAttributes
]

{ #category : 'accessing' }
GtTextEditorExternalText >> chunksToMeasure: chunkSize [
	^ GtTextEditorChunksToMeasure fromNativeHandle: (self primChunksToMeasure: chunkSize)
]

{ #category : 'gt - extensions' }
GtTextEditorExternalText >> gtChunksToMeasureFor: aView [
	<gtView>
	| chunkSize |
	
	chunkSize := 10.
	
	^ aView columnedList
		title: 'Chunks to measure';
		priority: 8;
		items: [ (self chunksToMeasure: chunkSize) asArray ];
		column: 'Range' text: [ :each | each range ] 
]

{ #category : 'gt - extensions' }
GtTextEditorExternalText >> gtTextFor: aView [
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

{ #category : 'gt - extensions' }
GtTextEditorExternalText >> gtTextWithReplacementsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Text and replacements';
		priority: 7;
		items: [ self textWithReplacements asArray ];
		column: 'Kind' text: [ :each | each kindName ];
		column: 'Range' text: [ :each | each range ] 
]

{ #category : 'initialization' }
GtTextEditorExternalText >> initialize [
	super initialize.
	
	adornments := Dictionary new
]

{ #category : 'text - modifications' }
GtTextEditorExternalText >> insertString: aString at: anIndex [
	self ffiLibrary newString: aString during: [ :aStringBox |
		| offset |
		offset := anIndex min: self size max: 0.
		self
			primInsertString: aStringBox
			offset:offset ]
]

{ #category : 'private - ffi' }
GtTextEditorExternalText >> primAddAttribute: anAttribute start: aStart end: anEnd [
	^ self ffiCall: #(void text_add_attribute(
		self,
		void* anAttribute,
		size_t aStart,
		size_t anEnd))
]

{ #category : 'private - ffi' }
GtTextEditorExternalText >> primChunksToMeasure: aChunkSize [
	^ self ffiCall: #(void* text_chunks_to_measure(self, size_t aChunkSize))
]

{ #category : 'private - ffi' }
GtTextEditorExternalText >> primCloneAttributes [
	^ self ffiCall: #(void* text_clone_attributes(self))
]

{ #category : 'private - ffi' }
GtTextEditorExternalText >> primInsertString: aStringBox offset: anOffset [
	^ self ffiCall: #(void text_insert_str(
		self,
		void* aStringBox,
		size_t anOffset))
]

{ #category : 'private - ffi' }
GtTextEditorExternalText >> primLen [
	^ self ffiCall: #(size_t text_len(self))
]

{ #category : 'private - ffi' }
GtTextEditorExternalText >> primTextWithReplacements [
	^ self ffiCall: #(void* text_with_replacements(self))
]

{ #category : 'accessing' }
GtTextEditorExternalText >> size [
	^ self primLen
]

{ #category : 'accessing' }
GtTextEditorExternalText >> textWithReplacements [
	^ GtTextEditorTextWithReplacements fromNativeHandle: self primTextWithReplacements
]
