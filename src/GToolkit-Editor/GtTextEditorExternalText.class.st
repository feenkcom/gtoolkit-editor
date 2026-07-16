Class {
	#name : 'GtTextEditorExternalText',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
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
GtTextEditorExternalText class >> primFromString: aStringBox [
	^ self ffiCall: #(void* text_from_string(void* aStringBox))
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalText class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void text_release(void* aHandle))
]

{ #category : 'text - attributes' }
GtTextEditorExternalText >> appendText: anExternalText anchor: anAttributeAnchor [
	GtTextEditorAppendingAttribute
		appendingText: anExternalText
		during: [ :appendingAttribute | 
			self
				appendingAttribute: appendingAttribute
				anchor: anAttributeAnchor ].
]

{ #category : 'text - attributes' }
GtTextEditorExternalText >> appendText: anExternalText at: anIndex [
	self
	 appendText: anExternalText
	 anchor: (GtTextEditorAttributeAnchor right: anIndex).
]

{ #category : 'text - attributes' }
GtTextEditorExternalText >> appendingAttribute: anAppendingAttribute anchor: anAttributeAnchor [
	self assert: [ anAppendingAttribute isKindOf: GtTextEditorAppendingAttribute ].
	
	self
		primAddAppendingAttribute: anAppendingAttribute
		anchor: anAttributeAnchor
]

{ #category : 'converting' }
GtTextEditorExternalText >> asGtTextEditorTextForTheme: aTheme during: aBlock [
	^ aBlock value: self
]

{ #category : 'converting' }
GtTextEditorExternalText >> asRopedText [
	^ self asString asRopedText
]

{ #category : 'converting' }
GtTextEditorExternalText >> asString [
	^ self ffiLibrary getStringFrom: [ :aStringBox | self primToString: aStringBox ]
]

{ #category : 'text - attributes' }
GtTextEditorExternalText >> attribute: aTextAttribute from: aStart to: anEnd [
	aTextAttribute asGtExternalTextAttributeDuring: [ :attr |
		self
			primAddAttribute: attr
			start: ((aStart - 1) max: 0)
			end: anEnd ]
]

{ #category : 'text - attributes' }
GtTextEditorExternalText >> background: aColor [
	GtTextEditorAttribute
		background: aColor
		during: [ :anAttribute | 
			self
				attribute: anAttribute
				from: 1
				to: self size ]
]

{ #category : 'text - attributes' }
GtTextEditorExternalText >> fontSize: aNumber [
	GtTextEditorAttribute
		fontSize: aNumber
		during: [ :anAttribute | 
			self
				attribute: anAttribute
				from: 1
				to: self size ]
]

{ #category : 'text - attributes' }
GtTextEditorExternalText >> foreground: aColor [
	GtTextEditorAttribute
		foreground: aColor
		during: [ :anAttribute | 
			self
				attribute: anAttribute
				from: 1
				to: self size ]
]

{ #category : 'gt - extensions' }
GtTextEditorExternalText >> gtChunksToMeasureFor: aView [
	"<gtView>"
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
				margin: (BlInsets all: 10);
				matchParent;
				text: self ];
		actionUpdateButton
]

{ #category : 'gt - extensions' }
GtTextEditorExternalText >> gtTextWithReplacementsFor: aView [
	"<gtView>"
	
	^ aView columnedList
		title: 'Text and replacements';
		priority: 7;
		items: [ self textWithReplacements asArray ];
		column: 'Kind' text: [ :each | each kindName ];
		column: 'Range' text: [ :each | each range ] 
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
GtTextEditorExternalText >> primAddAppendingAttribute: anAttribute anchor: anAttributeAnchor [
	^ self ffiBareCall: #(void text_add_appending_attribute(
		self,
		void* anAttribute,
		void* anAttributeAnchor))
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
GtTextEditorExternalText >> primGetPhlowVTable [
	^ self ffiCall: #(void* text_phlow_vtable(self))
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
GtTextEditorExternalText >> primToString: aStringBox [
	^ self ffiCall: #(void text_to_string(self, void* aStringBox))
]

{ #category : 'accessing' }
GtTextEditorExternalText >> size [
	^ self primLen
]
