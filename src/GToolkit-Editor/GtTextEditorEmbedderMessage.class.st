Class {
	#name : 'GtTextEditorEmbedderMessage',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Model-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Model-Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMessage class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMessage >> sendTo: anObject [
	self subclassResponsibility
]
