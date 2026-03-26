Class {
	#name : 'GtExpandedCoderElementWithRustTextEditorStencil',
	#superclass : 'GtCoderElementStencil',
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'api - instantiation' }
GtExpandedCoderElementWithRustTextEditorStencil >> defaultElement [
	<return: #BlElement>
	^ GtSourceCoderExpandedContentElement new
		initializeEditorElement: GtTextEditorElement new
]
