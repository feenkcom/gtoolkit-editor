Class {
	#name : 'GtTextEditorEmbedderLayoutReadyMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderLayoutReadyMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_layout_ready_message_release(void* aHandle))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderLayoutReadyMessage >> adornmentPosition: adornmentId ifPresent: aFoundBlock ifAbsent: ifAbsentBlock [
	^ self ffiLibrary newPointF32During: [ :aBoxedPoint |
		(self primGetAdornmentPosition: adornmentId point: aBoxedPoint)
			ifTrue: [ aFoundBlock value: aBoxedPoint asPoint ]
			ifFalse: [ ifAbsentBlock value ] ]
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderLayoutReadyMessage >> editorExtent [
	^ self ffiLibrary newPointF32During: [ :aBoxedPoint |
		self primGetEditorSize: aBoxedPoint.
		aBoxedPoint asPoint ]
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderLayoutReadyMessage >> primGetAdornmentPosition: adornmentId point: boxerPoint [
	^ self ffiCall: #(bool to_embedder_layout_ready_message_get_adornment_position(
		self,
		uint64 adornmentId,
		void* boxerPoint))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderLayoutReadyMessage >> primGetEditorSize: boxerPoint [
	^ self ffiCall: #(bool to_embedder_layout_ready_message_get_size(
		self,
		void* boxerPoint))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderLayoutReadyMessage >> sendTo: anObject [
	anObject onEditorLayoutReady: self
]
