Class {
	#name : 'GtTextEditorCursorMoveAttribute',
	#superclass : 'GtTextEditorAttribute',
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void caret_move_attribute_release(void* aHandle))
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute class >> primWithAttributeOnEnterOverSelf: aGtTextExternalAttribute [
	^ self ffiCall: #(void* caret_move_attribute_new_add_attributes_over_self_on_enter_remove_on_leave(void* aGtTextExternalAttribute))
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute class >> primWithAttributeOnLeave: aGtTextExternalAttribute overMarker: aMarkerTag [
	^ self ffiCall: #(void* caret_move_attribute_new_remove_attributes_over_marker_on_enter_add_on_leave(void* aGtTextExternalAttribute, uint64 aMarkerTag))
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute class >> primWithAttributeOnLeaveOverSelf: aGtTextExternalAttribute [
	^ self ffiCall: #(void* caret_move_attribute_new_remove_attributes_over_self_on_enter_add_on_leave(void* aGtTextExternalAttribute))
]

{ #category : 'instance creation' }
GtTextEditorCursorMoveAttribute class >> withAttributeOnEnter: aGtTextExternalAttribute during: aBlock [
	^ self
		fromNativeHandle: (self primWithAttributeOnEnterOverSelf: aGtTextExternalAttribute)
		during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorCursorMoveAttribute class >> withAttributeOnLeave: aGtTextExternalAttribute during: aBlock [
	^ self
		fromNativeHandle: (self primWithAttributeOnLeaveOverSelf: aGtTextExternalAttribute)
		during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorCursorMoveAttribute class >> withAttributeOnLeave: aGtTextExternalAttribute overMarker: aMarkerTag during: aBlock [
	^ self
		fromNativeHandle: (self primWithAttributeOnLeave: aGtTextExternalAttribute overMarker: aMarkerTag)
		during: aBlock
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute >> primAsAttribute [
	^ self ffiCall: #(void* caret_move_attribute_into_attribute(self))
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute >> primGetTag [
	^ self ffiCall: #(uint64 caret_move_attribute_get_tag(self))
]
