Class {
	#name : #GtTextEditorAdornmentAttribute,
	#superclass : #GtTextEditorAttribute,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorAdornmentAttribute class >> primCreate [
	^ self ffiCall: #(void* adornment_attribute_new())
]

{ #category : #'as yet unclassified' }
GtTextEditorAdornmentAttribute class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void adornment_attribute_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorAdornmentAttribute >> id [
	^ self primGetId
]

{ #category : #'as yet unclassified' }
GtTextEditorAdornmentAttribute >> primAsAttribute [
	^ self ffiCall: #(void* adornment_attribute_into_attribute(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorAdornmentAttribute >> primGetId [
	^ self ffiCall: #(size_t adornment_attribute_get_id(self))
]
