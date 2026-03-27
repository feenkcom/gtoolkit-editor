Extension { #name : 'GtTextualCoderElement' }

{ #category : '*GToolkit-Editor' }
GtTextualCoderElement >> initializeEditorElement: aNewEditorElement [
	| anOldEditor |
	self assert: [ aNewEditorElement isKindOf: GtTextEditorElement ].
	
	anOldEditor := editorElement.
	editorElement := aNewEditorElement.
	self
		replaceChild: anOldEditor
		with: editorElement
		as: GtSourceCoderEditorInnerId.

	aNewEditorElement
		aptitude: BrGlamorousCodeEditorAptitude;
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude menu: [ self createContextMenu ]);
		padding: BlInsets empty.

	completion ifNotNil: [ :aCompletion | 
		aCompletion uninstall.
		completion := nil ].

	self initializeEditorListeners.
	
	"I think this can be removed once  `BrTextEditorModificationEvent` works."
	self editor
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | self onTextModifiedDueToEvent: anEvent ].

	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	self onTextualCoderViewModelChanged.
	self onPostTextualCoderViewModelChanged
]
