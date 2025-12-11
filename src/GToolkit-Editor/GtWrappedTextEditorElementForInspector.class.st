Class {
	#name : 'GtWrappedTextEditorElementForInspector',
	#superclass : 'Object',
	#instVars : [
		'editorElement'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'as yet unclassified' }
GtWrappedTextEditorElementForInspector >> createEditorDebugElement [
	^ GtTextEditorDebugElement new
			matchParent;
			editorElement: editorElement
			yourself
]

{ #category : 'accessing' }
GtWrappedTextEditorElementForInspector >> editorElement [
	^ editorElement
]

{ #category : 'accessing' }
GtWrappedTextEditorElementForInspector >> editorElement: anObject [
	editorElement := anObject
]

{ #category : 'as yet unclassified' }
GtWrappedTextEditorElementForInspector >> gtDisplayOn: stream [
	editorElement gtDisplayOn: stream
]

{ #category : 'as yet unclassified' }
GtWrappedTextEditorElementForInspector >> gtInspectorTitleString [
	^ editorElement gtInspectorTitleString
]

{ #category : 'as yet unclassified' }
GtWrappedTextEditorElementForInspector >> gtLiveFor: aView [
	<gtView>
	
	^ aView forward
			priority: 1;
			title: 'Live';
			object: [
				editorElement hasParent
					ifTrue: [ editorElement ]
					ifFalse: [
						self createEditorDebugElement
					]
			
 ];
			view: #gtLiveFor:
]
