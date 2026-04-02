Class {
	#name : 'GtTextEditorRange',
	#superclass : 'Object',
	#instVars : [
		'start',
		'end',
		'documentId'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorRange class >> new [
	(self == GtTextEditorRange)
		ifTrue: [ self error: 'Choose one of the concrete subclasses' ].
		
	^ super new
]

{ #category : 'instance creation' }
GtTextEditorRange class >> start: aStart end: anEnd documentId: aDocumentId [
	^ self new
		setStart: aStart
		end: anEnd
		documentId: aDocumentId
]

{ #category : 'accessing' }
GtTextEditorRange >> documentId [
	^ documentId
]

{ #category : 'accessing' }
GtTextEditorRange >> end [
	^ end
]

{ #category : 'printing' }
GtTextEditorRange >> gtDisplayOn: stream [
	stream
		nextPutAll: self typeName;
		space;
		nextPut: $[;
		print: start;
		nextPutAll: ' .. ';
		print: end;
		nextPut: $)
]

{ #category : 'testing' }
GtTextEditorRange >> isByteRange [
	^ false
]

{ #category : 'testing' }
GtTextEditorRange >> isCharacterRange [
	^ false
]

{ #category : 'initialization' }
GtTextEditorRange >> setStart: aStart end: anEnd documentId: aDocumentId [
	start := aStart.
	end := anEnd.
	documentId := aDocumentId
]

{ #category : 'accessing' }
GtTextEditorRange >> start [
	^ start
]

{ #category : 'printing' }
GtTextEditorRange >> typeName [
	^ self subclassResponsibility
]
