Extension { #name : 'BrTextEditorSelectionMemento' }

{ #category : '*GToolkit-Editor' }
BrTextEditorSelectionMemento >> restoreStateOfNewEditor: aTextEditor [
	aTextEditor deselectAll.

	self flag: #TODO
]
