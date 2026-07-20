Class {
	#name : 'GtTextEditorCaretMoveSelectionBehavior',
	#superclass : 'GtExternalEnumeration',
	#classVars : [
		'Ignore',
		'PreserveCaretEnter',
		'TriggerCaretEnter'
	],
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'accessing enum' }
GtTextEditorCaretMoveSelectionBehavior class >> Ignore [
	"This method was automatically generated"
	^ Ignore
]

{ #category : 'accessing enum' }
GtTextEditorCaretMoveSelectionBehavior class >> PreserveCaretEnter [
	"This method was automatically generated"
	^ PreserveCaretEnter
]

{ #category : 'accessing enum' }
GtTextEditorCaretMoveSelectionBehavior class >> TriggerCaretEnter [
	"This method was automatically generated"
	^ TriggerCaretEnter
]

{ #category : 'enum declaration' }
GtTextEditorCaretMoveSelectionBehavior class >> externalDeclaration [
	"self rebuildEnumAccessors"
	
	^ #(
    Ignore,
    TriggerCaretEnter,
    PreserveCaretEnter,
	)
]

{ #category : 'enum declaration' }
GtTextEditorCaretMoveSelectionBehavior class >> externalType [
	^ FFIUInt8 new
]

{ #category : 'as yet unclassified' }
GtTextEditorCaretMoveSelectionBehavior class >> initialize [
	super initialize
]
