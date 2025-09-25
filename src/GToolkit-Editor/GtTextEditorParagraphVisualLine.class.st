Class {
	#name : #GtTextEditorParagraphVisualLine,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorParagraphVisualLine class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorParagraphVisualLine class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void visual_line_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorParagraphVisualLine >> end [
	^ self primEnd
]

{ #category : #'as yet unclassified' }
GtTextEditorParagraphVisualLine >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 5;
		items: [ {'Range' -> self range} ];
		column: 'Property' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ];
		send: [ :each | each value ]
]

{ #category : #'as yet unclassified' }
GtTextEditorParagraphVisualLine >> primEnd [
	^ self ffiCall: #(size_t visual_line_end(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorParagraphVisualLine >> primStart [
	^ self ffiCall: #(size_t visual_line_start(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorParagraphVisualLine >> range [
	^ GtTextEditorTextRange start: self start end: self end
]

{ #category : #'as yet unclassified' }
GtTextEditorParagraphVisualLine >> start [
	^ self primStart
]
