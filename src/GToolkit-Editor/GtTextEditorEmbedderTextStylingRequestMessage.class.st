Class {
	#name : 'GtTextEditorEmbedderTextStylingRequestMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

{ #category : 'dispatching' }
GtTextEditorEmbedderTextStylingRequestMessage >> sendTo: anObject [
	anObject onEditorTextStylingRequest: self
]
