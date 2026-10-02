"
I carry an announcement observed on some announcer into Beacon, so that announcements and editor signals share one ordered, timestamped sink instead of being collected separately and merged afterwards.

I deliberately know nothing about the announcement classes I carry. ${class:GtTextEditorTimelineRecorder}$ subscribes generically, which is what keeps `GToolkit-Editor` free of any dependency on the packages that define them.
"
Class {
	#name : 'GtTextEditorAnnouncementSignal',
	#superclass : 'GtTextEditorSignal',
	#instVars : [
		'announcement',
		'label'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorAnnouncementSignal >> announcement [
	^ announcement
]

{ #category : 'accessing' }
GtTextEditorAnnouncementSignal >> announcement: anObject [
	announcement := anObject
]

{ #category : 'accessing' }
GtTextEditorAnnouncementSignal >> announcementClassName [
	"Answer the name of the announcement I carry, without holding a reference to its class."
	<return: #String>
	^ announcement class name
]

{ #category : 'accessing' }
GtTextEditorAnnouncementSignal >> label [
	^ label
]

{ #category : 'accessing' }
GtTextEditorAnnouncementSignal >> label: anObject [
	label := anObject
]

{ #category : 'printing' }
GtTextEditorAnnouncementSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPutAll: label;
		nextPutAll: ': ';
		nextPutAll: self announcementClassName;
		space
]
