Class {
	#name : 'GtTextEditorCursorMoveAttribute',
	#superclass : 'GtTextEditorAttribute',
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'instance creation' }
GtTextEditorCursorMoveAttribute class >> newWithTag: anAttributeTag during: aBlock [
	^ self fromNativeHandle: (self primCreateWithTag: anAttributeTag) during: aBlock
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute class >> primCreate [
	^ self ffiCall: #(void* caret_move_attribute_new())
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute class >> primCreateWithTag: anAttributeTag [
	^ self ffiCall: #(void* caret_move_attribute_new_with_tag(uint64 anAttributeTag))
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void caret_move_attribute_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorCursorMoveAttribute >> addCursorEnterAction: anEventAction [
	self primAddCaretEnterAction: anEventAction
]

{ #category : 'as yet unclassified' }
GtTextEditorCursorMoveAttribute >> addCursorLeaveAction: anEventAction [
	self primAddCaretLeaveAction: anEventAction
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute >> primAddCaretEnterAction: aEventHandlingAction [
	self ffiCall: #(void caret_move_attribute_add_caret_enter_action(self, void* aEventHandlingAction))
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute >> primAddCaretLeaveAction: aEventHandlingAction [
	self ffiCall: #(void caret_move_attribute_add_caret_leave_action(self, void* aEventHandlingAction))
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute >> primAsAttribute [
	^ self ffiCall: #(void* caret_move_attribute_into_attribute(self))
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute >> primGetTag [
	^ self ffiCall: #(uint64 caret_move_attribute_get_tag(self))
]

{ #category : 'private - ffi' }
GtTextEditorCursorMoveAttribute >> primSetSelectionBehavior: aCaretMoveSelectionBehavior [
	self ffiCall: #(void caret_move_attribute_set_selection_behavior(self, GtTextEditorCaretMoveSelectionBehavior aCaretMoveSelectionBehavior))
]

{ #category : 'as yet unclassified' }
GtTextEditorCursorMoveAttribute >> selectionBehavior: aCaretMoveSelectionBehavior [
	self primSetSelectionBehavior: aCaretMoveSelectionBehavior
]
