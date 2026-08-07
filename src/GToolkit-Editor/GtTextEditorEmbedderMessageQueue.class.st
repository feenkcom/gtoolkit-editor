Class {
	#name : 'GtTextEditorEmbedderMessageQueue',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMessageQueue class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMessageQueue class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void editor_embedder_messages_release(void* aHandle))
]

{ #category : 'accessing' }
GtTextEditorEmbedderMessageQueue >> pollMessageDuring: aBlock ifAbsent: anAbsentBlock [
	"Subscribe to the cursor reached boundary event and return an event handler"
	| typeBuffer messageHandle messageType messageClasses |
	
	typeBuffer := ByteArray new: FFIUInt8 externalTypeSize.
	messageHandle := self primPollMessage: typeBuffer.
	messageHandle isNull
		ifTrue: [ ^ anAbsentBlock value ].
	messageType := typeBuffer unsignedByteAt: 1.
	
	messageClasses := {
		GtTextEditorEmbedderLayoutReadyMessage.
		GtTextEditorEmbedderMeasureAdornmentMessage.
		GtTextEditorEmbedderAdornmentMeasuredMessage.
		GtTextEditorEmbedderAdornmentsAddedMessage.
		GtTextEditorEmbedderAdornmentsRemovedMessage.
		GtTextEditorEmbedderActiveCaretMovedMessage.
		GtTextEditorEmbedderCaretsChangedMessage.
		GtTextEditorEmbedderTextEventMessage.
		GtTextEditorEmbedderTextChangedMessage.
		GtTextEditorEmbedderTextCompletionRequestMessage.
		GtTextEditorEmbedderTextStylingRequestMessage.
		GtTextEditorEmbedderPerformActionMessage.
		GtTextEditorEmbedderScrollEdgeReachedMessage.
		GtTextEditorEmbedderCursorReachedBoundaryMessage }.

	^ (messageClasses at: messageType ifAbsent: [ ^ self ])
		fromNativeHandle: messageHandle
		during: aBlock
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMessageQueue >> primPollMessage: messageTypePointer [
	^ self ffiCall: #(void* editor_embedder_messages_poll(self, void* messageTypePointer))
]
