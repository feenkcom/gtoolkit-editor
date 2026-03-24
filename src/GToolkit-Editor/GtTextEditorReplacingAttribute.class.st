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

{ #category : 'as yet unclassified' }
GtTextEditorReplacingAttribute class >> primCreate [
	^ self ffiCall: #(void* replacing_attribute_new())
]

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
GtTextEditorReplacingAttribute >> attributeTag [
	^ self primGetId
]

{ #category : 'as yet unclassified' }
GtTextEditorReplacingAttribute >> isAdornmentAttribute [
	^ true
]

{ #category : 'as yet unclassified' }
GtTextEditorReplacingAttribute >> primAsAttribute [
	^ self ffiCall: #(void* replacing_attribute_into_attribute(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorReplacingAttribute >> primGetTag [
	^ self ffiCall: #(uint64 replacing_attribute_get_tag(self))
]
