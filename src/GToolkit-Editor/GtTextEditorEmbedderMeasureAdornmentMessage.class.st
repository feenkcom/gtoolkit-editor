Class {
	#name : 'GtTextEditorEmbedderMeasureAdornmentMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMeasureAdornmentMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_measure_adornment_message_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMeasureAdornmentMessage >> adornmentTag [
	^ self primGetAdornmentId
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMeasureAdornmentMessage >> primGetAdornmentId [
	^ self ffiCall: #(uint64 to_embedder_measure_adornment_message_get_id(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMeasureAdornmentMessage >> sendTo: anObject [
	anObject onEditorMeasureAdornment: self
]
