Class {
	#name : 'GtTextEditorAppendingAttribute',
	#superclass : 'GtTextEditorAttribute',
	#instVars : [
		'adornmentAttribute'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorAppendingAttribute class >> appendingText: anExternalText during: aBlock [
	^ GtTextEditorAppendingAttribute
			fromNativeHandle: (self primAppendingText: anExternalText)
			during: aBlock
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute class >> primAppendingText: aText [
	^ self ffiCall: #(void* appending_attribute_new_text(void* aText))
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute class >> primCreate [
	^ self ffiCall: #(void* appending_attribute_new())
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void appending_attribute_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorAppendingAttribute >> adornmentAttribute [
	^ adornmentAttribute
]

{ #category : 'accessing' }
GtTextEditorAppendingAttribute >> adornmentAttribute: anObject [
	adornmentAttribute := anObject
]

{ #category : 'accessing' }
GtTextEditorAppendingAttribute >> beExactHeight: aNumber [
	self primSetExactAdornmentHeight: aNumber
]

{ #category : 'accessing' }
GtTextEditorAppendingAttribute >> beExactWidth: aNumber [
	self primSetExactAdornmentWidth: aNumber
]

{ #category : 'accessing' }
GtTextEditorAppendingAttribute >> isAdornmentAttribute [
	^ true
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute >> primAsAttribute [
	^ self ffiCall: #(void* appending_attribute_into_attribute(self))
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute >> primGetTag [
	^ self ffiCall: #(uint64 appending_attribute_get_tag(self))
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute >> primSetExactAdornmentHeight: aNumber [
	^ self ffiCall: #(void appending_attribute_set_exact_height(self, float64 aNumber))
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute >> primSetExactAdornmentWidth: aNumber [
	^ self ffiCall: #(void appending_attribute_set_exact_width(self, float64 aNumber))
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute >> primSetOverwritableByStyler: aBoolean [
	^ self ffiCall: #(void appending_attribute_set_overwritable_by_styler(self, bool aBoolean))
]

{ #category : 'accessing' }
GtTextEditorAppendingAttribute >> setOverwritableByStyler: aBoolean [
	self primSetOverwritableByStyler: aBoolean
]
