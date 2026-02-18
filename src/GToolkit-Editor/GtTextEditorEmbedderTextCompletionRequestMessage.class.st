Class {
	#name : 'GtTextEditorEmbedderTextCompletionRequestMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

{ #category : 'dispatching' }
GtTextEditorEmbedderTextCompletionRequestMessage >> sendTo: anObject [
	anObject onEditorTextCompletionRequest: self
]
