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
