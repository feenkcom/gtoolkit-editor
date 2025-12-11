Class {
	#name : 'GtTextEditorInspectorTool',
	#superclass : 'GtInspectorTool',
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'as yet unclassified' }
GtTextEditorInspectorTool class >> priority [
	<return: #Number>
	^ 2
]

{ #category : 'as yet unclassified' }
GtTextEditorInspectorTool >> icon [
	^ BrGlamorousVectorIcons rustLogo
]
