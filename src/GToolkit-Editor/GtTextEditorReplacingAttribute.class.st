Class {
	#name : 'GtTextEditorReplacingAttribute',
	#superclass : 'GtTextEditorAttribute',
	#instVars : [
		'adornmentAttribute'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'instance creation' }
GtTextEditorReplacingAttribute class >> newWithTag: anAttributeTag during: aBlock [
	^ self fromNativeHandle: (self primCreateWithTag: anAttributeTag) during: aBlock
]

{ #category : 'private - ffi' }
GtTextEditorReplacingAttribute class >> primCreate [
	^ self ffiCall: #(void* replacing_attribute_new())
]

{ #category : 'private - ffi' }
GtTextEditorReplacingAttribute class >> primCreateWithTag: anAttributeTag [
	^ self ffiCall: #(void* replacing_attribute_new_with_tag(uint64 anAttributeTag))
]

{ #category : 'private - ffi' }
GtTextEditorReplacingAttribute class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void replacing_attribute_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorReplacingAttribute >> adornmentAttribute [
	^ adornmentAttribute
]

{ #category : 'accessing' }
GtTextEditorReplacingAttribute >> adornmentAttribute: anObject [
	adornmentAttribute := anObject
]

{ #category : 'testing' }
GtTextEditorReplacingAttribute >> isAdornmentAttribute [
	^ true
]

{ #category : 'private - ffi' }
GtTextEditorReplacingAttribute >> primAsAttribute [
	^ self ffiCall: #(void* replacing_attribute_into_attribute(self))
]

{ #category : 'private - ffi' }
GtTextEditorReplacingAttribute >> primGetTag [
	^ self ffiCall: #(uint64 replacing_attribute_get_tag(self))
]
