Class {
	#name : 'GtTextEditorEmbedderAdornmentMeasuredMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderAdornmentMeasuredMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_adornment_measured_message_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorEmbedderAdornmentMeasuredMessage >> adornmentTag [
	^ self primGetAdornmentId
]

{ #category : 'accessing' }
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

{ #category : 'message - dispatch' }
GtTextEditorEmbedderAdornmentMeasuredMessage >> sendTo: anObject [
	anObject onEditorAdornmentMeasured: self
]
