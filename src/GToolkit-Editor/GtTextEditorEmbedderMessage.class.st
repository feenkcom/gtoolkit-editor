Class {
	#name : 'GtTextEditorEmbedderMessage',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMessage class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'message - dispatch' }
GtTextEditorEmbedderMessage >> sendTo: anObject [
	self subclassResponsibility
]
