"
I record what happened during one editor run, from every source at once, into a single ordered timeline.

I collect Beacon signals with a memory logger, and I subscribe to any announcer I am given, re-emitting each announcement as a ${class:GtTextEditorAnnouncementSignal}$ so that announcements and signals land in the same sink rather than in two lists that have to be merged afterwards.

I subscribe generically, with `when: Announcement do:`, and never name an announcement class. That is what lets me observe a coder view model without `GToolkit-Editor` depending on the packages that define its announcements. The caller passes me the announcer:

```
aRecorder := GtTextEditorTimelineRecorder new
	observeAnnouncer: aCoderViewModel announcer labeled: 'coder view model';
	start
```

Beacon timestamps are not fine grained enough to order events that land in the same millisecond, which here is the common case, so I stamp every entry with my own monotonic sequence number and order by it.
"
Class {
	#name : 'GtTextEditorTimelineRecorder',
	#superclass : 'Object',
	#instVars : [
		'memoryLogger',
		'announcements',
		'signalClasses',
		'executionResult',
		'isEnabled'
	],
	#classVars : [
		'IsEnabled'
	],
	#category : 'GToolkit-Editor-Debugging',
	#package : 'GToolkit-Editor',
	#tag : 'Debugging'
}

{ #category : 'settings' }
GtTextEditorTimelineRecorder class >> isEnabled [
	^ IsEnabled ifNil: [ false ]
]

{ #category : 'settings' }
GtTextEditorTimelineRecorder class >> isEnabled: aBoolean [
	IsEnabled := aBoolean
]

{ #category : 'initialization' }
GtTextEditorTimelineRecorder >> defaultSignalClasses [
	"The signals worth putting on one timeline when an editor run is being explained.

	Deliberately narrow. GtTextEditorSignal itself must not be used: it is a ContextStackSignal,
	so every emit captures a full call stack, and its layout, measure and request layout
	subclasses fire continuously for every live editor in the image. Recording that class makes
	the image unusable rather than slow."
	<return: #Collection>
	^ {ExceptionSignal.
		GtTextEditorSignal.
		"GtTextEditorTextSetSignal.
		GtTextEditorStylingRequestedSignal.
		GtTextEditorStyledTextAppliedSignal.
		GtTextEditorStyledTextRejectedSignal.
		GtTextEditorEmbedderUnknownMessageSignal.
		GtTextEditorAttributeSignal.
		GtTextEditorAnnouncementSignal.
		BlTextStylerRequestedSignal."
		BrAsyncElementFutureAboutToCancelPromiseSignal.
		BrAsyncElementFutureSkippedFutureSignal}
]

{ #category : 'accessing' }
GtTextEditorTimelineRecorder >> executionResult [
	^ executionResult
]

{ #category : 'views' }
GtTextEditorTimelineRecorder >> gtInfoFor: aView [
	<gtView>
	^ aView details
		title: 'Info';
		row: 'Recorded events'
			value: [ self ]
			text: [ :aRecorder | aRecorder memoryLogger recordingsCount printString ];
		row: 'Observed announcers'
			value: [ announcements ]
			text: [ :theAnnouncements | theAnnouncements size printString ];
		row: 'Signal classes'
			value: [ signalClasses ]
			text: [ :theClasses | (theClasses collect: [ :each | each name ]) asArray printString ]
]

{ #category : 'views' }
GtTextEditorTimelineRecorder >> gtTimelineFor: aView [
	<gtView>
	memoryLogger hasRecordings ifFalse: [ ^ aView empty ].

	^ aView columnedList
		title: 'Timeline';
		items: [ self timeline ];
		column: '#' text: [ :anEntry | anEntry sequence ] width: 50;
		column: 'Source' text: [ :anEntry | anEntry source ] width: 150;
		column: 'Event' text: [ :anEntry | anEntry name ] width: 300;
		column: 'Details' text: [ :anEntry | anEntry details ]
]

{ #category : 'initialization' }
GtTextEditorTimelineRecorder >> initialize [
	super initialize.
	memoryLogger := MemoryLogger new.
	
	announcements := OrderedCollection new.
	signalClasses := self defaultSignalClasses.
	executionResult := nil
]

{ #category : 'running' }
GtTextEditorTimelineRecorder >> isEnabled [
	^ isEnabled ifNil: [ self class isEnabled ].
]

{ #category : 'accessing' }
GtTextEditorTimelineRecorder >> memoryLogger [
	<return: #MemoryLogger>
	^ memoryLogger
]

{ #category : 'observing' }
GtTextEditorTimelineRecorder >> observeAnnouncer: anAnnouncer announcement: anAnnouncementClass labeled: aString [
	"Re-emit everything anAnnouncer announces as a beacon signal tagged with aString."

	announcements
		add: (GtTextEditorTimelineAnnouncement new
				announcer: anAnnouncer;
				announcementClass: anAnnouncementClass;
				label: aString)
]

{ #category : 'observing' }
GtTextEditorTimelineRecorder >> observeAnnouncer: anAnnouncer labeled: aString [
	self
		observeAnnouncer: anAnnouncer
		announcement: Announcement
		labeled: aString
]

{ #category : 'printing' }
GtTextEditorTimelineRecorder >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: memoryLogger recordingsCount;
		nextPutAll: ' entries)'
]

{ #category : 'running' }
GtTextEditorTimelineRecorder >> runDuring: aBlock [
	"Collect for the duration of aBlock, stopping even if it fails."

	self start.
	^ [ [ executionResult := aBlock value ]
		onErrorDo: [ :anError | 
			executionResult := GtSystemUtility freeze: anError.
			anError pass ] ] ensure: [ self stop ]
]

{ #category : 'accessing' }
GtTextEditorTimelineRecorder >> signalClasses [
	<return: #Collection>
	^ signalClasses
]

{ #category : 'accessing' }
GtTextEditorTimelineRecorder >> signalClasses: aCollection [
	signalClasses := aCollection
]

{ #category : 'private' }
GtTextEditorTimelineRecorder >> sourceOfSignal: aSignal [
	"Answer where aSignal came from, so a timeline can be read by source without unpacking it."
	<return: #String>
	^ (aSignal isKindOf: GtTextEditorAnnouncementSignal)
		ifTrue: [ aSignal label ]
		ifFalse: [ 'editor' ]
]

{ #category : 'running' }
GtTextEditorTimelineRecorder >> start [
	"Start collecting."

	| aSignalSet |
	self isEnabled ifFalse: [ ^ self ].
	(signalClasses isEmpty and: [ announcements isEmpty ]) ifTrue: [ ^ self ].

	aSignalSet := signalClasses allButFirst
			inject: signalClasses first
			into: [ :aSet :eachClass | aSet , eachClass ].

	memoryLogger startFor: aSignalSet.
	announcements do: #subscribe
]

{ #category : 'running' }
GtTextEditorTimelineRecorder >> stop [
	"Stop collecting."

	announcements do: #unsubscribe.
	memoryLogger stop
]

{ #category : 'accessing' }
GtTextEditorTimelineRecorder >> timeline [
	"Answer what was recorded, oldest first.
	The logger appends in arrival order, so the index is the ordering. Timestamps are not,
	because they only resolve to the millisecond and most of these events share one."
	<return: #Array of: #GtTextEditorTimelineEntry>
	| theRecordings |
	theRecordings := memoryLogger recordings.
	^ (1 to: theRecordings size)
		collect: [ :anIndex |
			| aSignal |
			aSignal := theRecordings at: anIndex.
			GtTextEditorTimelineEntry new
				sequence: anIndex;
				timestamp: aSignal timestamp;
				source: (self sourceOfSignal: aSignal);
				signal: aSignal;
				yourself ]
]

{ #category : 'accessing' }
GtTextEditorTimelineRecorder >> timelineFor: anEditorElement [
	"Answer the timeline restricted to anEditorElement, keeping every entry that is not tied to
	any element. Signals are global, so a run recorded while other editors are alive in the image
	picks them up too."
	<return: #Array of: #GtTextEditorTimelineEntry>
	^ self timeline select: [ :anEntry |
		| anElement |
		anElement := anEntry elementOrNil.
		anElement isNil or: [ anElement == anEditorElement ] ]
]
