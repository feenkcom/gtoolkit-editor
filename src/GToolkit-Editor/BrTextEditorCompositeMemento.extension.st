Extension { #name : 'BrTextEditorCompositeMemento' }

{ #category : '*GToolkit-Editor' }
BrTextEditorCompositeMemento >> restoreStateOfNewEditor: aTextEditor [
	mementos do: [ :eachMemento | eachMemento restoreStateOfNewEditor: aTextEditor ]
]
