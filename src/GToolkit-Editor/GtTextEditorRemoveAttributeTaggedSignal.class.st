Class {
	#name : 'GtTextEditorRemoveAttributeTaggedSignal',
	#superclass : 'GtTextEditorAttributeSignal',
	#instVars : [
		'attributeTag'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
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
