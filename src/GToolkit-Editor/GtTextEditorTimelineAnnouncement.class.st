"
I am one announcer subscription held by a ${class:GtTextEditorTimelineRecorder}$, and I turn each announcement I see into a ${class:GtTextEditorAnnouncementSignal}$ so that announcements reach the same Beacon sink as the signals and need no merging afterwards.

I subscribe weakly and `send:to:` rather than with a block, so a recorder that is dropped without being stopped does not keep the announcer firing into it.

My `announcementClass` is what the recorder narrows an observation to. It is `Announcement` for a generic observation, which is how a coder view model can be observed without `GToolkit-Editor` depending on the package that defines its announcements.
"
Class {
	#name : 'GtTextEditorTimelineAnnouncement',
	#superclass : 'Object',
	#instVars : [
		'announcer',
		'announcementClass',
		'label',
		'subscription'
	],
	#category : 'GToolkit-Editor-Debugging',
	#package : 'GToolkit-Editor',
	#tag : 'Debugging'
}

{ #category : 'accessing' }
GtTextEditorTimelineAnnouncement >> announcementClass [
	^ announcementClass
]

{ #category : 'accessing' }
GtTextEditorTimelineAnnouncement >> announcementClass: anObject [
	announcementClass := anObject
]

{ #category : 'accessing' }
GtTextEditorTimelineAnnouncement >> announcer [
	^ announcer
]

{ #category : 'accessing' }
GtTextEditorTimelineAnnouncement >> announcer: anObject [
	announcer := anObject
]

{ #category : 'accessing' }
GtTextEditorTimelineAnnouncement >> label [
	^ label
]

{ #category : 'accessing' }
GtTextEditorTimelineAnnouncement >> label: anObject [
	label := anObject
]

{ #category : 'event handling' }
GtTextEditorTimelineAnnouncement >> onAnnouncement: anAnnouncement [
	GtTextEditorAnnouncementSignal new
		announcement: anAnnouncement;
		label: self label;
		emit
]

{ #category : 'running' }
GtTextEditorTimelineAnnouncement >> subscribe [
	subscription := self announcer weak
			when: self announcementClass
			send: #onAnnouncement:
			to: self
]

{ #category : 'accessing' }
GtTextEditorTimelineAnnouncement >> subscription [
	^ subscription
]

{ #category : 'running' }
GtTextEditorTimelineAnnouncement >> unsubscribe [
	self announcer unsubscribe: self.
	subscription := nil
]
