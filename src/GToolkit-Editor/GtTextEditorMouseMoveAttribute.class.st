Class {
	#name : 'GtTextEditorMouseMoveAttribute',
	#superclass : 'GtTextEditorAttribute',
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'private - ffi' }
GtTextEditorMouseMoveAttribute class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void mouse_move_attribute_release(void* aHandle))
]

{ #category : 'private - ffi' }
GtTextEditorMouseMoveAttribute class >> primWithAttributeOnHoverOverSelf: aGtTextExternalAttribute [
	^ self ffiCall: #(void* mouse_move_attribute_new_add_attributes_over_self_on_hover_remove_on_leave(void* aGtTextExternalAttribute))
]

{ #category : 'instance creation' }
GtTextEditorMouseMoveAttribute class >> withAttributeOnHover: aGtTextExternalAttribute during: aBlock [
	^ self
		fromNativeHandle: (self primWithAttributeOnHoverOverSelf: aGtTextExternalAttribute)
		during: aBlock
]

{ #category : 'private - ffi' }
GtTextEditorMouseMoveAttribute >> primAsAttribute [
	^ self ffiCall: #(void* mouse_move_attribute_into_attribute(self))
]

{ #category : 'private - ffi' }
GtTextEditorMouseMoveAttribute >> primGetTag [
	^ self ffiCall: #(uint64 mouse_move_attribute_get_tag(self))
]
