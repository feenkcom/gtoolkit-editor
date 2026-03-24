Class {
	#name : 'GtTextEditorMetrics',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'as yet unclassified' }
GtTextEditorMetrics class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void editor_metrics_release(void* aHandle))
]

{ #category : 'views' }
GtTextEditorMetrics >> gtDetailsViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 3;
		items: [ {'Width' -> self width.
				'Height' -> self height.
				'Viewport top' -> (self viewportTop ifNil: [ 'None' ]).
				'Viewport height' -> (self viewportHeight ifNil: [ 'None' ])} ];
		column: 'Property' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ];
		send: [ :each | each value ]
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> gtParagraphsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Paragraphs';
		priority: 5;
		items: [ self paragraphs ];
		column: 'Range' text: [ :each | each range ]
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> height [
	^ self primGetHeight
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> paragraphs [
	^ GtTextEditorParagraphs
		fromNativeHandle: self primGetParagraphs
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> primGetHeight [
	^ self ffiCall: #(float64 editor_metrics_height(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> primGetParagraphs [
	^ self ffiCall: #(void* editor_metrics_clone_paragraphs(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> primGetViewportHeight [
	^ self ffiCall: #(float64 editor_metrics_viewport_height_or_zero(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> primGetViewportTop [
	^ self ffiCall: #(float64 editor_metrics_viewport_top_or_zero(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> primGetVisualLineAtX: anX y: anY [
	^ self ffiCall: #(void* editor_metrics_visual_line_at_point(
		self,
		float64 anX,
		float64 anY))
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> primGetWidth [
	^ self ffiCall: #(float64 editor_metrics_width(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> primHasViewportHeight [
	^ self ffiCall: #(bool editor_metrics_has_viewport_height(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> primHasViewportTop [
	^ self ffiCall: #(bool editor_metrics_has_viewport_top(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> viewportHeight [
	^ self primHasViewportHeight
			ifTrue: [ self primGetViewportHeight ]
			ifFalse: [ nil ]
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> viewportTop [
	^ self primHasViewportTop
			ifTrue: [ self primGetViewportTop ]
			ifFalse: [ nil ]
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> visualLineAtByteOffset: byteOffset [
	^ (self paragraphs paragraphAtByteOffset: byteOffset)
		ifNotNil: [ :paragraph | 
			(paragraph chunkAtByteOffset: byteOffset)
				ifNotNil: [ :chunk | chunk visualLineAtByteOffset: byteOffset ] ]
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> visualLineAtPoint: aPoint [
	| aHandle |
	aHandle := self primGetVisualLineAtX: aPoint x y: aPoint y.
	^ aHandle isNull
		ifTrue: [ nil ]
		ifFalse: [ GtTextEditorParagraphVisualLine fromNativeHandle: aHandle ]
]

{ #category : 'as yet unclassified' }
GtTextEditorMetrics >> width [
	^ self primGetWidth
]
