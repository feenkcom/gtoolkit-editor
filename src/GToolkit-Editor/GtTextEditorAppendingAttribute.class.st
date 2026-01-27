Class {
	#name : 'GtTextEditorAppendingAttribute',
	#superclass : 'GtTextEditorAttribute',
	#instVars : [
		'adornmentAttribute'
	],
	#category : 'GToolkit-Editor-FFI-Text',
	#package : 'GToolkit-Editor',
	#tag : 'FFI-Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorAppendingAttribute class >> appendingText: anExternalText during: aBlock [
	^ GtTextEditorAppendingAttribute
			fromNativeHandle: (self primAppendingText: anExternalText)
			during: aBlock
]

{ #category : 'as yet unclassified' }
GtTextEditorAppendingAttribute class >> primAppendingText: aText [
	^ self ffiCall: #(void* appending_attribute_new_text(void* aText))
]

{ #category : 'as yet unclassified' }
GtTextEditorAppendingAttribute class >> primCreate [
	^ self ffiCall: #(void* appending_attribute_new())
]

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
GtTextEditorAppendingAttribute >> attributeTag [
	^ self primGetTag
]

{ #category : 'as yet unclassified' }
GtTextEditorAppendingAttribute >> isAdornmentAttribute [
	^ true
]

{ #category : 'as yet unclassified' }
GtTextEditorAppendingAttribute >> primAsAttribute [
	^ self ffiCall: #(void* appending_attribute_into_attribute(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorAppendingAttribute >> primGetTag [
	^ self ffiCall: #(uint64 appending_attribute_get_tag(self))
]
