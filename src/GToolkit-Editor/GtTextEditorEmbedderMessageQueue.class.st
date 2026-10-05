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
	"Poll one message from the editor and evaluate aBlock with it.
	The order of messageClasses is the order of the rust ToEmbedderMessageType enumeration.

	Polling takes ownership of the message: whoever receives it has to release it, which
	#fromNativeHandle:during: does from an ensure:. A message type with no class here is dropped
	without being released, so its allocation leaks. Releasing it would mean knowing its type,
	which is exactly what is missing, so the mismatch is reported instead of repaired."
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
		GtTextEditorEmbedderCursorReachedBoundaryMessage.
		GtTextEditorEmbedderAdornmentsVisibleMessage.
		GtTextEditorEmbedderAdornmentsGoneMessage.
		GtTextEditorEmbedderStyledTextRejectedMessage }.

	^ (messageClasses
		at: messageType
		ifAbsent: [
			GtTextEditorEmbedderUnknownMessageSignal new
					messageType: messageType;
					knownTypesCount: messageClasses size;
					emit;
					reportToStderr.
			^ self ])
		fromNativeHandle: messageHandle
		during: aBlock
]

{ #category : 'as yet unclassified' }
GtTextEditorEmbedderMessageQueue >> primPollMessage: messageTypePointer [
	^ self ffiCall: #(void* editor_embedder_messages_poll(self, void* messageTypePointer))
]
