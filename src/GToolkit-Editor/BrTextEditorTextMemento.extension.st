Extension { #name : 'BrTextEditorTextMemento' }

{ #category : '*GToolkit-Editor' }
BrTextEditorTextMemento >> restoreStateOfNewEditor: aTextEditor [
	aTextEditor restoreText: text copy
]
