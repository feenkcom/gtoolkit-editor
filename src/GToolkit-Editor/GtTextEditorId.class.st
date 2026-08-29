"
I identify one Rust-backed text editor instance.
"
Class {
	#name : 'GtTextEditorId',
	#superclass : 'Object',
	#instVars : [
		'id'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'instance creation' }
GtTextEditorId class >> withId: anId [
	^ self new id: anId
]

{ #category : 'comparing' }
GtTextEditorId >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	self class = anObject class ifFalse: [ ^ false ].

	^ self id = anObject id
]

{ #category : 'comparing' }
GtTextEditorId >> hash [
	^ self class hash hashMultiply bitXor: self id hash hashMultiply
]

{ #category : 'accessing' }
GtTextEditorId >> id [
	^ id
]

{ #category : 'accessing' }
GtTextEditorId >> id: anId [
	id := anId
]

{ #category : 'printing' }
GtTextEditorId >> printOn: aStream [
	aStream
		nextPutAll: 'EditorId(id: ';
		print: self id;
		nextPutAll: ')'
]
