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
			self fromNativeHandle: (self primNew: aStringBox) ]
]

{ #category : #'as yet unclassified' }
GtTextEditorModel class >> primNew: aStringBox [
	^ self ffiCall: #(void* editor_new(void* aStringBox))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void editor_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorModel >> height [
	^ self primGetHeight
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
GtTextEditorModel >> primGetHeight [
	self ffiCall: #(float64 editor_get_height(self))
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
