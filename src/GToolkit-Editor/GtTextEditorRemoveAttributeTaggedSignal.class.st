Class {
	#name : 'GtTextEditorRemoveAttributeTaggedSignal',
	#superclass : 'GtTextEditorAttributeSignal',
	#instVars : [
		'attributeTag'
	],
	#category : 'GToolkit-Editor-Signals',
	#package : 'GToolkit-Editor',
	#tag : 'Signals'
}

{ #category : 'accessing' }
GtTextEditorRemoveAttributeTaggedSignal >> attributeTag [
	^ attributeTag
]

{ #category : 'accessing' }
GtTextEditorRemoveAttributeTaggedSignal >> attributeTag: anObject [
	attributeTag := anObject
]

{ #category : 'printing' }
GtTextEditorRemoveAttributeTaggedSignal >> printOneLineContentsOn: stream [
	stream
		nextPutAll: '- ';
		print: attributeTag
]
