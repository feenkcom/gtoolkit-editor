Class {
	#name : 'GtTextEditorProcess',
	#superclass : 'Object',
	#instVars : [
		'editorProcess',
		'semaphore',
		'editors',
		'semaphoreIndex'
	],
	#classInstVars : [
		'currentInstance'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'cleanup' }
GtTextEditorProcess class >> cleanUp: aggressive [
	aggressive ifTrue: [ currentInstance := nil ]
]

{ #category : 'accessing' }
GtTextEditorProcess class >> current [
	^ currentInstance ifNil: [ currentInstance := self new ]
]

{ #category : 'private' }
GtTextEditorProcess >> editorProcessStatus [
	editorProcess ifNil: [ ^ 'not started' ].
	self isTerminating ifTrue: [ ^ 'terminating' ].
	self isTerminated ifTrue: [ ^ 'terminated' ].
	self isSuspended ifTrue: [ ^ 'suspended' ].
	^ 'running'
]

{ #category : 'api - process' }
GtTextEditorProcess >> ensureEditorProcess [
	(editorProcess isNil or: [ editorProcess isSuspended or: [ editorProcess isTerminated or: [ editorProcess isTerminating ] ] ])
		ifFalse: [ ^ self ].
		
	editorProcess := [ self runEditorProcess ] forkAt: Processor userInterruptPriority named: 'Editors'.
]

{ #category : 'finalization' }
GtTextEditorProcess >> finalize [
	semaphore ifNotNil: [ Smalltalk unregisterExternalObject: semaphore ].
	editorProcess ifNotNil: #terminate.
]

{ #category : 'views' }
GtTextEditorProcess >> gtEditorsFor: aView [
	<gtView>
	editors ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Editors';
		items: [ editors asOrderedCollection ];
		column: 'Editor' text: [ :each | each gtDisplayString ]
]

{ #category : 'initialization' }
GtTextEditorProcess >> initialize [
	super initialize.
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.

	editors := WeakIdentitySet new
]

{ #category : 'testing' }
GtTextEditorProcess >> isSuspended [
	^ editorProcess ifNotNil: #isSuspended ifNil: [ false ]
]

{ #category : 'testing' }
GtTextEditorProcess >> isTerminated [
	^ editorProcess ifNotNil: #isTerminated ifNil: [ true ]
]

{ #category : 'testing' }
GtTextEditorProcess >> isTerminating [
	^ editorProcess ifNotNil: #isTerminating ifNil: [ false ]
]

{ #category : 'printing' }
GtTextEditorProcess >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: self editorProcessStatus;
		nextPutAll: ', editors: ';
		print: (editors ifNotNil: #size);
		nextPutAll: ')'
]

{ #category : 'api - process' }
GtTextEditorProcess >> registerEditor: aGtTextEditorElement [
	editors add: aGtTextEditorElement
]

{ #category : 'api - process' }
GtTextEditorProcess >> requestUpdates [
	editors do: #pollEditorMessagesRequest
]

{ #category : 'api - process' }
GtTextEditorProcess >> runEditorProcess [
	[ semaphore wait.
		self requestUpdates 
	] repeat
]

{ #category : 'accessing' }
GtTextEditorProcess >> semaphoreIndex [
	^ semaphoreIndex
]

{ #category : 'api - process' }
GtTextEditorProcess >> unregisterEditor: aGtTextEditorElement [
	editors remove: aGtTextEditorElement ifAbsent: [  ]
]
