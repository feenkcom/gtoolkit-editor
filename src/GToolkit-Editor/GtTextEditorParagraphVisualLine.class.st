Class {
	#name : 'GtTextEditorParagraphVisualLine',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Model',
	#package : 'GToolkit-Editor',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
GtTextEditorParagraphVisualLine class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphVisualLine class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void visual_line_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorParagraphVisualLine >> bounds [
	^ (self left @ self top) extent: self extent
]

{ #category : 'accessing' }
GtTextEditorParagraphVisualLine >> end [
	^ self primEnd
]

{ #category : 'accessing' }
GtTextEditorParagraphVisualLine >> extent [
	^ self width @ self height
]

{ #category : 'as yet unclassified' }
GtTextEditorParagraphVisualLine >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 5;
		items: [
			{
				'Range' -> self range.
				'Bounds' -> self bounds } ];
		column: 'Property' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ];
		send: [ :each | each value ]
]

{ #category : 'accessing' }
GtTextEditorParagraphVisualLine >> height [
	^ self primHeight
]

{ #category : 'accessing' }
GtTextEditorParagraphVisualLine >> left [
	^ self primLeft
]

{ #category : 'private - ffi' }
GtTextEditorParagraphVisualLine >> primEnd [
	^ self ffiCall: #(size_t visual_line_end(self))
]

{ #category : 'private - ffi' }
GtTextEditorParagraphVisualLine >> primHeight [
	^ self ffiCall: #(float64 visual_line_height(self))
]

{ #category : 'private - ffi' }
GtTextEditorParagraphVisualLine >> primLeft [
	^ self ffiCall: #(float64 visual_line_left(self))
]

{ #category : 'private - ffi' }
GtTextEditorParagraphVisualLine >> primStart [
	^ self ffiCall: #(size_t visual_line_start(self))
]

{ #category : 'private - ffi' }
GtTextEditorParagraphVisualLine >> primTop [
	^ self ffiCall: #(float64 visual_line_top(self))
]

{ #category : 'private - ffi' }
GtTextEditorParagraphVisualLine >> primWidth [
	^ self ffiCall: #(float64 visual_line_width(self))
]

{ #category : 'accessing' }
GtTextEditorParagraphVisualLine >> range [
	^ GtTextEditorTextRange start: self start end: self end
]

{ #category : 'accessing' }
GtTextEditorParagraphVisualLine >> start [
	^ self primStart
]

{ #category : 'accessing' }
GtTextEditorParagraphVisualLine >> top [
	^ self primTop
]

{ #category : 'accessing' }
GtTextEditorParagraphVisualLine >> width [
	^ self primWidth
]
