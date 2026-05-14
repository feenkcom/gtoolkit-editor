Class {
	#name : 'GtTextEditorAddAttributeOverMarkerSignal',
	#superclass : 'GtTextEditorAttributeSignal',
	#instVars : [
		'attribute',
		'attributeTag',
		'markerAttribute'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorAddAttributeOverMarkerSignal >> attribute [
	^ attribute
]

{ #category : 'accessing' }
GtTextEditorAddAttributeOverMarkerSignal >> attribute: anObject [
	attribute := anObject
]

{ #category : 'accessing' }
GtTextEditorAddAttributeOverMarkerSignal >> attributeTag [
	^ attributeTag
]

{ #category : 'accessing' }
GtTextEditorAddAttributeOverMarkerSignal >> attributeTag: anObject [
	attributeTag := anObject
]

{ #category : 'accessing' }
GtTextEditorAddAttributeOverMarkerSignal >> markerAttribute [
	^ markerAttribute
]

{ #category : 'accessing' }
GtTextEditorAddAttributeOverMarkerSignal >> markerAttribute: anObject [
	markerAttribute := anObject
]
