"
I am one event on a ${class:GtTextEditorTimelineRecorder}$ timeline.

My `sequence` is the recorder's monotonic counter and is what orders me. My `timestamp` comes from the signal and is only accurate to the millisecond, so it is for reading, not for ordering.
"
Class {
	#name : 'GtTextEditorTimelineEntry',
	#superclass : 'Object',
	#instVars : [
		'sequence',
		'timestamp',
		'source',
		'signal'
	],
	#category : 'GToolkit-Editor-Debugging',
	#package : 'GToolkit-Editor',
	#tag : 'Debugging'
}

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> details [
	"Answer the signal's own one line description, or an empty string when it has none."
	<return: #String>
	^ [ String streamContents: [ :aStream | signal printOneLineContentsOn: aStream ] ]
		on: Error
		do: [ :anError | '' ]
]

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> elementOrNil [
	"Answer the editor element this entry belongs to, or nil when it belongs to none.
	Not every signal carries one, and those that do not are kept by any element filter."
	^ (signal respondsTo: #element)
		ifTrue: [ signal element ]
		ifFalse: [ nil ]
]

{ #category : 'views' }
GtTextEditorTimelineEntry >> gtSignalOneLineFor: aView [
	<gtView>
	signal ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'One line';
		object: [ signal ];
		view: #gtOneLineFor:
]

{ #category : 'views' }
GtTextEditorTimelineEntry >> gtSignalPropertiesFor: aView [
	<gtView>
	signal ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Properties';
		object: [ signal ];
		view: #gtPropertiesFor:
]

{ #category : 'views' }
GtTextEditorTimelineEntry >> gtSignalReferencesFor: aView [
	<gtView>
	signal ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'References';
		object: [ signal ];
		view: #gtReferencesFor:
]

{ #category : 'views' }
GtTextEditorTimelineEntry >> gtSignalStackFor: aView [
	<gtView>
	signal ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Stack';
		object: [ signal ];
		view: #gtStackFor:
]

{ #category : 'views' }
GtTextEditorTimelineEntry >> gtSignalTopMethodFor: aView [
	<gtView>
	signal ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Source';
		object: [ signal ];
		view: #gtViewTopMethodFor:
]

{ #category : 'views' }
GtTextEditorTimelineEntry >> gtSignalTopVariablesFor: aView [
	<gtView>
	signal ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Top variables';
		object: [ signal ];
		view: #gtViewTopVariablesFor:
]

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> name [
	"Answer what happened, short enough for a column."
	<return: #String>
	^ (signal isKindOf: GtTextEditorAnnouncementSignal)
		ifTrue: [ signal announcementClassName ]
		ifFalse: [ signal class name ]
]

{ #category : 'printing' }
GtTextEditorTimelineEntry >> printOn: aStream [
	aStream
		print: sequence;
		nextPutAll: ' [';
		nextPutAll: source;
		nextPutAll: '] ';
		nextPutAll: self name
]

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> sequence [
	<return: #Number>
	^ sequence
]

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> sequence: aNumber [
	sequence := aNumber
]

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> signal [
	^ signal
]

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> signal: anObject [
	signal := anObject
]

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> source [
	<return: #String>
	^ source
]

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> source: aString [
	source := aString
]

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> timestamp [
	^ timestamp
]

{ #category : 'accessing' }
GtTextEditorTimelineEntry >> timestamp: anObject [
	timestamp := anObject
]
