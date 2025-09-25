Class {
	#name : #GtTextEditorAppendingAttribute,
	#superclass : #GtTextEditorAttribute,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorAppendingAttribute class >> primCreate [
	^ self ffiCall: #(void* appending_adornment_attribute_new())
]

{ #category : #'as yet unclassified' }
GtTextEditorAppendingAttribute class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void appending_attribute_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorAppendingAttribute >> primAsAttribute [
	^ self ffiCall: #(void* appending_attribute_into_attribute(self))
]
