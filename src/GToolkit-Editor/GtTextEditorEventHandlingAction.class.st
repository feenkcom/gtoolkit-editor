Class {
	#name : 'GtTextEditorEventHandlingAction',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'instance creation' }
GtTextEditorEventHandlingAction class >> addAttribute: anExternalAttribute overMarker: aMarkerAttributeTag during: aBlock [
	^ self
		fromNativeHandle: (self primNewAddAttribute: anExternalAttribute overMarker: aMarkerAttributeTag)
		during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorEventHandlingAction class >> addAttributeOverSelf: anExternalAttribute during: aBlock [
	^ self
		fromNativeHandle: (self primNewAddAttributeOverSelf: anExternalAttribute)
		during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorEventHandlingAction class >> addAttributeOverSelf: anExternalAttribute firstCharacters: aCharCount during: aBlock [
	^ self
		fromNativeHandle: (self primNewAddAttributeOverSelf: anExternalAttribute firstCharacters: aCharCount)
		during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorEventHandlingAction class >> addAttributeOverSelf: anExternalAttribute lastCharacters: aCharCount during: aBlock [
	^ self
		fromNativeHandle: (self primNewAddAttributeOverSelf: anExternalAttribute lastCharacters: aCharCount)
		during: aBlock
]

{ #category : 'as yet unclassified' }
GtTextEditorEventHandlingAction class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'private - ffi' }
GtTextEditorEventHandlingAction class >> primNewAddAttribute: anExternalAttribute overMarker: anAttributeTag [
	^ self ffiCall: #(void* event_handling_action_new_add_attributes(uint64 anAttributeTag, void* anExternalAttribute))
]

{ #category : 'private - ffi' }
GtTextEditorEventHandlingAction class >> primNewAddAttributeOverSelf: anExternalAttribute [
	^ self ffiCall: #(void* event_handling_action_new_add_attributes_over_self(void* anExternalAttribute))
]

{ #category : 'private - ffi' }
GtTextEditorEventHandlingAction class >> primNewAddAttributeOverSelf: anExternalAttribute firstCharacters: aCharCount [
	^ self ffiCall: #(void* event_handling_action_new_add_attributes_over_self_first_characters(
		void* anExternalAttribute,
		size_t aCharCount))
]

{ #category : 'private - ffi' }
GtTextEditorEventHandlingAction class >> primNewAddAttributeOverSelf: anExternalAttribute lastCharacters: aCharCount [
	^ self ffiCall: #(void* event_handling_action_new_add_attributes_over_self_last_characters(
		void* anExternalAttribute,
		size_t aCharCount))
]

{ #category : 'private - ffi' }
GtTextEditorEventHandlingAction class >> primNewNotifyEmbedder [
	^ self ffiCall: #(void* event_handling_action_new_notify_embedder())
]

{ #category : 'private - ffi' }
GtTextEditorEventHandlingAction class >> primNewRemoveAttribute: anAttributeTag overMarker: aMarkerAttributeTag [
	^ self ffiCall: #(void* event_handling_action_new_add_attributes(
		uint64 aMarkerAttributeTag,
		uint64 anAttributeTag))
]

{ #category : 'private - ffi' }
GtTextEditorEventHandlingAction class >> primNewRemoveAttributeOverSelf: anAttributeTag [
	^ self ffiCall: #(void* event_handling_action_new_remove_attributes_over_self(uint64 anAttributeTag))
]

{ #category : 'private - ffi' }
GtTextEditorEventHandlingAction class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void event_handling_action_release(void* aHandle))
]

{ #category : 'instance creation' }
GtTextEditorEventHandlingAction class >> removeAttribute: anAttributeTag overMarker: aMarkerAttributeTag during: aBlock [
	^ self
		fromNativeHandle: (self primNewRemoveAttribute: anAttributeTag overMarker: aMarkerAttributeTag)
		during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorEventHandlingAction class >> removeAttributeOverSelf: anAttributeTag during: aBlock [
	^ self
		fromNativeHandle: (self primNewRemoveAttributeOverSelf: anAttributeTag)
		during: aBlock
]
