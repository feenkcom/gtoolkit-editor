Class {
	#name : 'GtTextEditorEmbedderTextModificationReason',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderTextModificationReason class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'accessing' }
GtTextEditorEmbedderTextModificationReason >> end [
	^ self primGetCharEnd
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextModificationReason >> primGetByteEnd [
	^ self subclassResponsibility
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextModificationReason >> primGetByteStart [
	^ self subclassResponsibility
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextModificationReason >> primGetCharEnd [
	^ self subclassResponsibility
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextModificationReason >> primGetCharStart [
	^ self subclassResponsibility
]

{ #category : 'message - dispatch' }
GtTextEditorEmbedderTextModificationReason >> sendTo: anObject with: anotherObject [
	self subclassResponsibility
]

{ #category : 'accessing' }
GtTextEditorEmbedderTextModificationReason >> start [
	^ self primGetCharStart
]
