Class {
	#name : 'GtTextEditorTextClassifier',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'library path' }
GtTextEditorTextClassifier class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'private - ffi' }
GtTextEditorTextClassifier class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void text_classifier_kind_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorTextClassifier class >> primSmalltalkWord [
	^ self ffiCall: #(void* text_classifier_kind_smalltalk_word())
]

{ #category : 'as yet unclassified' }
GtTextEditorTextClassifier class >> smalltalkWordDuring: aBlock [
	^ self fromNativeHandle: self primSmalltalkWord during: aBlock
]
