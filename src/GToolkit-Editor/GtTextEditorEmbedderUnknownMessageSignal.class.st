"
I am emitted when the editor library sends a message type this image has no class for.

That happens when the rust `ToEmbedderMessageType` enumeration gains a variant and the dispatch table in ${method:GtTextEditorEmbedderMessageQueue>>#pollMessageDuring:ifAbsent:}$ is not extended with it. The message is then dropped, and its native handle is leaked, because releasing it would mean knowing its type, which is exactly what is missing. The leak is one allocation per message of that type.

A beacon signal is invisible in a headless run, so I also write one line to stderr, where a CI log will show it. I write once per message type per session, so a library that keeps sending an unknown message reports the mismatch without flooding the log.
"
Class {
	#name : 'GtTextEditorEmbedderUnknownMessageSignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'messageType',
		'knownTypesCount'
	],
	#classVars : [
		'ReportedMessageTypes'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'reporting' }
GtTextEditorEmbedderUnknownMessageSignal class >> resetReportedMessageTypes [
	"Forget which message types were already written to stderr, so they are written again."
	ReportedMessageTypes := Set new
]

{ #category : 'reporting' }
GtTextEditorEmbedderUnknownMessageSignal class >> shouldReportMessageType: aMessageType ifNeeded: aBlock [
	"Evaluate aBlock only the first time aMessageType is seen in this session."
	ReportedMessageTypes ifNil: [ ReportedMessageTypes := Set new ].
	(ReportedMessageTypes includes: aMessageType) ifTrue: [ ^ self ].
	ReportedMessageTypes add: aMessageType.
	^ aBlock value
]

{ #category : 'accessing' }
GtTextEditorEmbedderUnknownMessageSignal >> knownTypesCount [
	^ knownTypesCount
]

{ #category : 'accessing' }
GtTextEditorEmbedderUnknownMessageSignal >> knownTypesCount: anObject [
	knownTypesCount := anObject
]

{ #category : 'accessing' }
GtTextEditorEmbedderUnknownMessageSignal >> messageType [
	^ messageType
]

{ #category : 'accessing' }
GtTextEditorEmbedderUnknownMessageSignal >> messageType: anObject [
	messageType := anObject
]

{ #category : 'printing' }
GtTextEditorEmbedderUnknownMessageSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPutAll: 'Unknown message type ';
		print: messageType;
		nextPutAll: ', this image knows ';
		print: knownTypesCount;
		nextPutAll: ' of them. The message was dropped and its handle leaked.'
]

{ #category : 'reporting' }
GtTextEditorEmbedderUnknownMessageSignal >> reportToStderr [
	"Write one line to stderr, so the mismatch is visible in a headless run where nothing is
	listening for beacon signals.
	Only the first occurrence of each message type is written: a library that keeps sending an
	unknown message would otherwise fill a CI log with the same line."

	self class
		shouldReportMessageType: messageType
		ifNeeded: [ [ NonInteractiveTranscript stderr
				nextPutAll: 'GtTextEditor: ';
				nextPutAll: (String streamContents: [ :aStream | self printOneLineContentsOn: aStream ]);
				newLine ]
				on: Error
				do: [ :anError | "stderr is not essential, never fail the message loop over it"  ] ]
]
