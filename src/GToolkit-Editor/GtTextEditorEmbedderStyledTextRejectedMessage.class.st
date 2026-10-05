"
I report that the rust editor discarded a styled text because it was computed for a different document.

My `expectedDocumentId` is the document the editor held when the styled text arrived, and my `receivedDocumentId` is the one the styled text was computed for. Comparing them says whether the text was edited during styling, in which case the revision moved, or a different text object was styled entirely, in which case the text id moved.

Without me a styling round that silently produced nothing cannot be told apart from one that was never requested.
"
Class {
	#name : 'GtTextEditorEmbedderStyledTextRejectedMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'private - ffi' }
GtTextEditorEmbedderStyledTextRejectedMessage class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_styled_text_rejected_message_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorEmbedderStyledTextRejectedMessage >> expectedDocumentId [
	"Answer the document the editor was holding when the styled text arrived."
	<return: #GtTextEditorDocumentId>
	| aDocumentId |
	aDocumentId := GtTextEditorDocumentId new.
	self primGetExpectedDocumentId: aDocumentId.
	^ aDocumentId
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderStyledTextRejectedMessage >> primGetExpectedDocumentId: aDocumentId [
	^ self ffiBareCall: #(bool to_embedder_styled_text_rejected_get_expected_document_id(self, void* aDocumentId))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderStyledTextRejectedMessage >> primGetReceivedDocumentId: aDocumentId [
	^ self ffiBareCall: #(bool to_embedder_styled_text_rejected_get_received_document_id(self, void* aDocumentId))
]

{ #category : 'accessing' }
GtTextEditorEmbedderStyledTextRejectedMessage >> receivedDocumentId [
	"Answer the document the discarded styled text was computed for."
	<return: #GtTextEditorDocumentId>
	| aDocumentId |
	aDocumentId := GtTextEditorDocumentId new.
	self primGetReceivedDocumentId: aDocumentId.
	^ aDocumentId
]

{ #category : 'accessing' }
GtTextEditorEmbedderStyledTextRejectedMessage >> sendTo: anObject [
	anObject onEditorStyledTextRejected: self
]
