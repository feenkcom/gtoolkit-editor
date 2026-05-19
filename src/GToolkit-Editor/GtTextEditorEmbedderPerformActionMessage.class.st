Class {
	#name : 'GtTextEditorEmbedderPerformActionMessage',
	#superclass : 'GtTextEditorEmbedderMessage',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderPerformActionMessage class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void to_embedder_perform_action_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorEmbedderPerformActionMessage >> actionId [
	^ self primGetActionId
]

{ #category : 'accessing' }
GtTextEditorEmbedderPerformActionMessage >> caretOffset [
	^ self primGetActiveCursor
]

{ #category : 'accessing' }
GtTextEditorEmbedderPerformActionMessage >> documentId [
	| documentId |
	
	documentId := GtTextEditorDocumentId new.
	self primGetDocumentId: documentId.
	^ documentId
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderPerformActionMessage >> primGetActionId [
	^ self ffiCall: #(uint64 to_embedder_perform_action_get_action_id(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderPerformActionMessage >> primGetActiveCursor [
	^ self ffiCall: #(size_t  to_embedder_perform_action_get_active_cursor_raw_offset(self))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderPerformActionMessage >> primGetDocumentId: documentId [
	^ self ffiBareCall: #(bool to_embedder_perform_action_get_document_id(self, void* documentId))
]

{ #category : 'private - ffi' }
GtTextEditorEmbedderPerformActionMessage >> primGetSelectedString: aStringBox [
	^ self ffiCall: #(bool  to_embedder_perform_action_get_selected_string(self, void* aStringBox))
]

{ #category : 'enumerating' }
GtTextEditorEmbedderPerformActionMessage >> selectedStringDo: aBlock ifAbsent: anAbsentBlock [
	| hasSelection selectedString |
	selectedString := self ffiLibrary
			getStringFrom: [ :aStringBox | hasSelection := self primGetSelectedString: aStringBox ].

	^ hasSelection
		ifTrue: [ aBlock value: selectedString ]
		ifFalse: [ anAbsentBlock value ]
]

{ #category : 'message - dispatch' }
GtTextEditorEmbedderPerformActionMessage >> sendTo: anObject [
	anObject onEditorPerformAction: self
]
