Class {
	#name : #GtTextEditorReplacingAttribute,
	#superclass : #GtTextEditorAttribute,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorReplacingAttribute class >> primCreate [
	^ self ffiCall: #(void* replacing_adornment_attribute_new())
]

{ #category : #'as yet unclassified' }
GtTextEditorReplacingAttribute class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void replacing_attribute_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorReplacingAttribute >> primAsAttribute [
	^ self ffiCall: #(void* replacing_attribute_into_attribute(self))
]
