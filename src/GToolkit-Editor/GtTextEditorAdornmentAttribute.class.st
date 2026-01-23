Class {
	#name : 'GtTextEditorAdornmentAttribute',
	#superclass : 'GtTextEditorAttribute',
	#instVars : [
		'adornmentAttribute'
	],
	#category : 'GToolkit-Editor-FFI-Text',
	#package : 'GToolkit-Editor',
	#tag : 'FFI-Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorAdornmentAttribute class >> primCreate [
	^ self ffiCall: #(void* adornment_attribute_new())
]

{ #category : 'as yet unclassified' }
GtTextEditorAdornmentAttribute class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void adornment_attribute_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorAdornmentAttribute >> adornmentAttribute [
	^ adornmentAttribute
]

{ #category : 'accessing' }
GtTextEditorAdornmentAttribute >> adornmentAttribute: anAdornmentAttribute [
	adornmentAttribute := anAdornmentAttribute
]

{ #category : 'as yet unclassified' }
GtTextEditorAdornmentAttribute >> beAppend [
	self primBeAppending
]

{ #category : 'as yet unclassified' }
GtTextEditorAdornmentAttribute >> beReplace [
	self primBeReplacing
]

{ #category : 'as yet unclassified' }
GtTextEditorAdornmentAttribute >> id [
	^ self primGetId
]

{ #category : 'as yet unclassified' }
GtTextEditorAdornmentAttribute >> isAdornmentAttribute [
	^ true
]

{ #category : 'as yet unclassified' }
GtTextEditorAdornmentAttribute >> primAsAttribute [
	^ self ffiCall: #(void* adornment_attribute_into_attribute(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorAdornmentAttribute >> primBeAppending [
	^ self ffiCall: #(void adornment_attribute_be_appending(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorAdornmentAttribute >> primBeReplacing [
	^ self ffiCall: #(void adornment_attribute_be_replacing(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorAdornmentAttribute >> primGetId [
	^ self ffiCall: #(uint64 adornment_attribute_get_id(self))
]
