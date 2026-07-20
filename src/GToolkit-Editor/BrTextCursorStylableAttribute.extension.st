Extension { #name : 'BrTextCursorStylableAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextCursorStylableAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorCursorMoveAttribute
		newDuring: [ :aCursorMoveAttribute | 
			self
				gtEditorInitializeCursorAttribute: aCursorMoveAttribute
				registry: anAttributesRegistry
				forTheme: aTheme.
			aBlock value: aCursorMoveAttribute ]
]

{ #category : '*GToolkit-Editor' }
BrTextCursorStylableAttribute >> gtEditorCreateExternalTextAttributeTagged: anExistingTag registry: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorCursorMoveAttribute
		newWithTag: anExistingTag
		during: [ :aCursorMoveAttribute | 
			self
				gtEditorInitializeCursorAttribute: aCursorMoveAttribute
				registry: anAttributesRegistry
				forTheme: aTheme.
			aBlock value: aCursorMoveAttribute ]
]

{ #category : '*GToolkit-Editor' }
BrTextCursorStylableAttribute >> gtEditorInitializeCursorAttribute: aCursorMoveAttribute registry: anAttributesRegistry forTheme: aTheme [
	cursorEnterActions
		do: [ :eachAction | 
			eachAction
				asGtTextEditorEventHandlingAction: anAttributesRegistry
				forTheme: aTheme
				during: [ :externalAction | aCursorMoveAttribute addCursorEnterAction: externalAction ] ].

	cursorLeaveActions
		do: [ :eachAction | 
			eachAction
				asGtTextEditorEventHandlingAction: anAttributesRegistry
				forTheme: aTheme
				during: [ :externalAction | aCursorMoveAttribute addCursorLeaveAction: externalAction ] ].

	selectionBehavior = IgnoreSelection
		ifTrue: [ aCursorMoveAttribute
				selectionBehavior: GtTextEditorCaretMoveSelectionBehavior Ignore ].

	selectionBehavior = SelectionTriggersCursorEnter
		ifTrue: [ aCursorMoveAttribute
				selectionBehavior: GtTextEditorCaretMoveSelectionBehavior TriggerCaretEnter ].

	selectionBehavior = SelectionPreservesCursorEnter
		ifTrue: [ aCursorMoveAttribute
				selectionBehavior: GtTextEditorCaretMoveSelectionBehavior PreserveCaretEnter ]
]

{ #category : '*GToolkit-Editor' }
BrTextCursorStylableAttribute >> gtEditorShouldBeAddedToRegistry [
	^ true
]
