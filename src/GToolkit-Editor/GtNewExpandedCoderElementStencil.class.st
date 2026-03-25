Class {
	#name : 'GtNewExpandedCoderElementStencil',
	#superclass : 'GtCoderElementStencil',
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'api - instantiation' }
GtNewExpandedCoderElementStencil >> defaultElement [
	<return: #BlElement>
	^ GtNewSourceCoderExpandedContentElement new
]
