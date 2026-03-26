Extension { #name : 'BrTextEditorHistoryMemento' }

{ #category : '*GToolkit-Editor' }
BrTextEditorHistoryMemento >> restoreStateOfNewEditor: aTextEditor [
	aTextEditor history: history copy
]
