Class {
	#name : 'GtTextEditorEmbedderTextChangedMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextChangedMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_text_changed_message_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorEmbedderTextChangedMessage >> documentId [
	| documentId |
	
	documentId := GtTextEditorDocumentId new.
	self primGetDocumentId: documentId.
	^ documentId
]

{ #category : 'enumerating' }
GtTextEditorEmbedderTextChangedMessage >> modificationReasonsDo: aBlock [
	| reasonTypeBuffer |
	self primHasModificationReasons ifFalse: [ ^ self ].

	reasonTypeBuffer := ByteArray
			new: GtTextEditorEmbedderModificationReasonType externalType externalTypeSize.

	[ | reasonType reasonPointer |
	reasonPointer := self primPopModificationReason: reasonTypeBuffer.
	reasonPointer isNull ifTrue: [ ^ self ].

	reasonType := GtTextEditorEmbedderModificationReasonType
			fromInteger: (reasonTypeBuffer unsignedByteAt: 1).

	reasonType = GtTextEditorEmbedderModificationReasonType Insertion
		ifTrue: [ GtTextEditorEmbedderTextInsertionReason
				fromNativeHandle: reasonPointer
				during: aBlock ].

	reasonType = GtTextEditorEmbedderModificationReasonType Deletion
		ifTrue: [ GtTextEditorEmbedderTextDeletionReason
				fromNativeHandle: reasonPointer
				during: aBlock ] ] repeat
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextChangedMessage >> primGetDocumentId: documentId [
	^ self ffiBareCall: #(bool to_embedder_text_changed_get_document_id(self, void* documentId))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextChangedMessage >> primGetText [
	^ self ffiCall: #(void* to_embedder_text_changed_message_get_text(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextChangedMessage >> primHasModificationReasons [
	^ self ffiCall: #(bool to_embedder_text_changed_message_has_modification_reasons(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderTextChangedMessage >> primPopModificationReason: aReasonTypePointer [
	^ self ffiBareCall: #(void* to_embedder_text_changed_message_pop_front_modification_reason(self, void* aReasonTypePointer))
]

{ #category : 'message - dispatch' }
GtTextEditorEmbedderTextChangedMessage >> sendTo: anObject [
	anObject onEditorTextChanged: self
]

{ #category : 'accessing' }
GtTextEditorEmbedderTextChangedMessage >> text [
	^ GtTextEditorExternalText fromNativeHandle: self primGetText
]
