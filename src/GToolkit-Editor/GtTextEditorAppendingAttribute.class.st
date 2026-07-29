Class {
	#name : 'GtTextEditorAppendingAttribute',
	#superclass : 'GtTextEditorAttribute',
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'instance creation' }
GtTextEditorAppendingAttribute class >> appendingText: anExternalText during: aBlock [
	^ self
			fromNativeHandle: (self primAppendingText: anExternalText)
			during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorAppendingAttribute class >> appendingText: anExternalText withTag: anAttributeTag during: aBlock [
	^ self
			fromNativeHandle: (self primAppendingText: anExternalText withTag: anAttributeTag)
			during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorAppendingAttribute class >> newWithTag: anAttributeTag during: aBlock [
	^ self fromNativeHandle: (self primCreateWithTag: anAttributeTag) during: aBlock
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute class >> primAppendingText: aText [
	^ self ffiCall: #(void* appending_attribute_new_text(void* aText))
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute class >> primAppendingText: aText withTag: anAttributeTag [
	^ self ffiCall: #(void* appending_attribute_new_text_with_tag(void* aText, uint64 anAttributeTag))
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute class >> primCreate [
	^ self ffiCall: #(void* appending_attribute_new())
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute class >> primCreateWithTag: anAttributeTag [
	^ self ffiCall: #(void* appending_attribute_new_with_tag(uint64 anAttributeTag))
]

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void appending_attribute_release(void* aHandle))
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

{ #category : 'private - ffi' }
GtTextEditorAppendingAttribute >> primSetToggleAppendingAttributeAction: anExternalAttribute [
	^ self ffiCall: #(void appending_attribute_set_toggle_appending_attribute_action(self, void* anExternalAttribute))
]

{ #category : 'accessing' }
GtTextEditorAppendingAttribute >> setOverwritableByStyler: aBoolean [
	self primSetOverwritableByStyler: aBoolean
]

{ #category : 'accessing' }
GtTextEditorAppendingAttribute >> setToggleAppendingAttributeAction: anExternalAttribute [
	self primSetToggleAppendingAttributeAction: anExternalAttribute
]
