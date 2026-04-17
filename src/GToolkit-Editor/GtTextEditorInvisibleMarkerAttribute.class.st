Class {
	#name : 'GtTextEditorInvisibleMarkerAttribute',
	#superclass : 'GtTextEditorAttribute',
	#instVars : [
		'markerAttribute'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'private - ffi' }
GtTextEditorInvisibleMarkerAttribute class >> primCreate [
	^ self ffiCall: #(void* marker_attribute_new())
]

{ #category : 'private - ffi' }
GtTextEditorInvisibleMarkerAttribute class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void marker_attribute_release(void* aHandle))
]

{ #category : 'testing' }
GtTextEditorInvisibleMarkerAttribute >> isMarkerAttribute [
	^ true
]

{ #category : 'accessing' }
GtTextEditorInvisibleMarkerAttribute >> markerAttribute [
	^ markerAttribute
]

{ #category : 'accessing' }
GtTextEditorInvisibleMarkerAttribute >> markerAttribute: anObject [
	markerAttribute := anObject
]

{ #category : 'private - ffi' }
GtTextEditorInvisibleMarkerAttribute >> primAsAttribute [
	^ self ffiCall: #(void* marker_attribute_into_attribute(self))
]

{ #category : 'private - ffi' }
GtTextEditorInvisibleMarkerAttribute >> primGetTag [
	^ self ffiCall: #(uint64 marker_attribute_get_tag(self))
]
