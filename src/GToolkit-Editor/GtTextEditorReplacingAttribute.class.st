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

{ #category : 'private - ffi' }
GtTextEditorReplacingAttribute class >> primReplacingText: aText [
	^ self ffiCall: #(void* replacing_attribute_new_text(void* aText))
]

{ #category : 'private - ffi' }
GtTextEditorReplacingAttribute class >> primReplacingText: aText withTag: anAttributeTag [
	^ self ffiCall: #(void* replacing_attribute_new_text_with_tag(void* aText, uint64 anAttributeTag))
]

{ #category : 'instance creation' }
GtTextEditorReplacingAttribute class >> replacingText: anExternalText during: aBlock [
	^ self
			fromNativeHandle: (self primReplacingText: anExternalText)
			during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorReplacingAttribute class >> replacingText: anExternalText withTag: anAttributeTag during: aBlock [
	^ self
		fromNativeHandle: (self primReplacingText: anExternalText withTag: anAttributeTag)
		during: aBlock
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

{ #category : 'private - ffi' }
GtTextEditorReplacingAttribute >> primSetOverwritableByStyler: aBoolean [
	^ self ffiCall: #(void replacing_attribute_set_overwritable_by_styler(self, bool aBoolean))
]

{ #category : 'accessing' }
GtTextEditorReplacingAttribute >> setOverwritableByStyler: aBoolean [
	"Tell the rust side whether a styling pass may remove this attribute.

	The counterpart of ${method:GtTextEditorAppendingAttribute>>#setOverwritableByStyler:}$. Until the rust
	side gained this setter the flag could not be carried for a replacing attribute at all, so an attribute
	the embedder had marked as its own arrived overwritable and the next styling pass removed it."
	self primSetOverwritableByStyler: aBoolean
]
