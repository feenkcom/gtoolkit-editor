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

{ #category : 'class initialization' }
GtTextEditorProcess class >> cleanUp: aggressive [
	"Discarding the instance without releasing its slot would leak one entry of the external
	objects table per cleanup, and leave its process waiting on a semaphore nobody signals."

	<script: 'self cleanUp: true'>
	aggressive ifFalse: [ ^ self ].
	currentInstance
		ifNotNil: [ :anInstance | 
			anInstance terminate.
			anInstance unregisterSemaphore ].
	currentInstance := nil
]

{ #category : 'accessing' }
GtTextEditorProcess class >> current [
	^ currentInstance ifNil: [ currentInstance := self new ]
]

{ #category : 'class initialization' }
GtTextEditorProcess class >> initialize [
	SessionManager default registerUserClassNamed: self name
]

{ #category : 'system startup' }
GtTextEditorProcess class >> shutDown: isImageQuitting [
	"Release my slot before the snapshot is written, so a saved image does not carry an index
	that looks valid but is not. Only when actually quitting: after a save-and-continue this
	session keeps running and must keep its registration."

	isImageQuitting ifFalse: [ ^ self ].
	currentInstance ifNotNil: [ :anInstance | anInstance unregisterSemaphore ]
]

{ #category : 'system startup' }
GtTextEditorProcess class >> startUp: isImageStarting [
	"Re-claim a slot in the external objects table, which the VM clears on restart.
	Only on a real start: after a save-and-continue the registration is still valid."

	isImageStarting ifFalse: [ ^ self ].
	currentInstance ifNotNil: [ :anInstance | anInstance reRegisterSemaphore ]
]

{ #category : 'private' }
GtTextEditorProcess >> editorProcessStatus [
	editorProcess ifNil: [ ^ 'not started' ].
	self isTerminating ifTrue: [ ^ 'terminating' ].
	self isTerminated ifTrue: [ ^ 'terminated' ].
	self isSuspended ifTrue: [ ^ 'suspended' ].
	^ 'running'
]

{ #category : 'accessing' }
GtTextEditorProcess >> editorsSnaphost [
	^ editors lock: [ :aSet | aSet asOrderedCollection ]
]

{ #category : 'private' }
GtTextEditorProcess >> ensureEditorProcess [
	(editorProcess isNil or: [ editorProcess isSuspended or: [ editorProcess isTerminated or: [ editorProcess isTerminating ] ] ])
		ifFalse: [ ^ self ].
		
	editorProcess := [ self runEditorProcess ] forkAt: Processor userInterruptPriority named: 'Editors'.
]

{ #category : 'initialization' }
GtTextEditorProcess >> finalize [
	self unregisterSemaphore.
	self terminate
]

{ #category : 'views' }
GtTextEditorProcess >> gtEditorsFor: aView [
	<gtView>
	editors ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Editors';
		items: [ self editorsSnaphost ];
		column: 'Editor' text: [ :each | each gtDisplayString ]
]

{ #category : 'initialization' }
GtTextEditorProcess >> initialize [
	super initialize.
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.

	editors := AsyncMutex for: WeakIdentitySet new
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
		print: (editors ifNotNil: [ self editorsSnaphost size ] ifNil: [ 0 ]);
		nextPutAll: ')'
]

{ #category : 'private - external objects' }
GtTextEditorProcess >> reRegisterSemaphore [
	"Claim a fresh slot in the external objects table.
	The VM clears that table on restart, because indices held by external code do not survive a
	snapshot, but I survive it myself: currentInstance is a class variable. Without re-claiming,
	I would keep the index I had in the previous session, which by then belongs to whichever
	subsystem registered there first - and the Rust editors would signal that subsystem instead
	of me, while my own process would never be woken.
	
	TODO: All registered editors should be restored and the new semaphoreIndex should be given."
	semaphore ifNil: [ ^ self ].
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	
	self flag: #TODO.
]

{ #category : 'api - process' }
GtTextEditorProcess >> registerEditor: aGtTextEditorElement [
	editors lock: [ :aSet | 
		| aSize | 
		aSize := aSet size.
		aSet add: aGtTextEditorElement.
		aSize = aSet size ifFalse: [
			self ensureEditorProcess ] ]
]

{ #category : 'api - process' }
GtTextEditorProcess >> requestUpdates [
	editors lock: [ :aSet | 
		aSet do: #pollEditorMessagesRequest ]
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

{ #category : 'private' }
GtTextEditorProcess >> terminate [
	editorProcess ifNotNil: #terminate.
	editorProcess := nil.
]

{ #category : 'api - process' }
GtTextEditorProcess >> unregisterEditor: aGtTextEditorElement [
	editors lock: [ :aSet | 
		aSet remove: aGtTextEditorElement ifAbsent: [  ].
		aSet isEmpty ifFalse: [
			self terminate ] ]
]

{ #category : 'private - external objects' }
GtTextEditorProcess >> unregisterSemaphore [
	"Give up my slot in the external objects table. Safe to send more than once."
	semaphore ifNotNil: [ Smalltalk unregisterExternalObject: semaphore ].
	semaphoreIndex := nil
]
