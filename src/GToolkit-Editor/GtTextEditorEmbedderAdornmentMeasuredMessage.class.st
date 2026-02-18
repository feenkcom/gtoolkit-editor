Class {
	#name : 'GtTextEditorEmbedderAdornmentMeasuredMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentMeasuredMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_adornment_measured_message_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentMeasuredMessage >> adornmentTag [
	^ self primGetAdornmentId
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentMeasuredMessage >> extent [
	^ self ffiLibrary newPointF32During: [ :aBoxedPoint |
		self primGetAdornmentSize: aBoxedPoint.
		aBoxedPoint asPoint ]
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentMeasuredMessage >> primGetAdornmentId [
	^ self ffiCall: #(uint64 to_embedder_adornment_measured_message_get_id(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentMeasuredMessage >> primGetAdornmentSize: aBoxerSizeF32 [
	^ self ffiCall: #(void to_embedder_adornment_measured_message_get_size(self, void* aBoxerSizeF32))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentMeasuredMessage >> sendTo: anObject [
	anObject onEditorAdornmentMeasured: self
]
