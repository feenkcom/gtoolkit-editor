Class {
	#name : #GtTextEditorModel,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorModel class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorModel class >> newString: aString [
	^ self ffiLibrary
		newString: aString
		during: [ :aStringBox |
			self fromNativeHandle: (self primNewString: aStringBox) ]
]

{ #category : #'as yet unclassified' }
GtTextEditorModel class >> newText: aGtTextEditorText [
	^ self fromNativeHandle: (self primNewText: aGtTextEditorText)
]

{ #category : #'as yet unclassified' }
GtTextEditorModel class >> primNewString: aStringBox [
	^ self ffiCall: #(void* editor_new_str(void* aStringBox))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel class >> primNewText: aText [
	^ self ffiCall: #(void* editor_new_text(void* aText))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void editor_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> gtParagraphsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Paragraphs';
		priority: 5;
		items: [ self paragraphs ];
		column: 'Range' text: [ :each | each range ]
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> height [
	^ self primGetHeight
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> insertString: aString at: anIndex [
	self ffiLibrary newString: aString during: [ :aStringBox |
		| offset |
		offset := anIndex min: self size max: 0.
		self
			primInsertString: aStringBox
			offset:offset ]
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> measureWidth: aWidth top: aTopOrNil height: aHeightOrNil [
	self
		primMeasureWidth: aWidth
		hasViewportTop: aTopOrNil isNotNil
		viewportTop: (aTopOrNil ifNil: [ 0.0])
		hasViewportHeight:  aHeightOrNil isNotNil
		viewportHeight: (aHeightOrNil ifNil: [ 0.0])
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> paragraphs [
	^ GtTextEditorParagraphs
		fromNativeHandle: self primGetParagraphs
		during: [ :paragraphs | paragraphs asArray ]
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> primGetHeight [
	self ffiCall: #(float64 editor_get_height(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> primGetParagraphs [
	^ self ffiCall: #(void* editor_clone_paragraphs(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> primInsertString: aStringBox offset: anOffset [
	^ self ffiCall: #(void editor_insert_str(
		self,
		void* aStringBox,
		size_t anOffset))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> primLen [
	^ self ffiCall: #(size_t editor_len(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> primMeasureWidth: aWidth hasViewportTop: hasViewportTop viewportTop: viewportTop hasViewportHeight:  hasViewportHeight viewportHeight: viewportHeight [
	self ffiCall: #(void editor_measure(
		self,
		float64 aWidth,
		bool hasViewportTop,
		float64 viewportTop,
		bool hasViewportHeight,
		float64 viewportHeight))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> primScrollBy: aY [
	self ffiCall: #(void editor_scroll_by(self, float64 aY))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> scrollBy: aY [
	self primScrollBy: aY
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> size [
	^ self primLen
]
