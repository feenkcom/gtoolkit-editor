Class {
	#name : #GtTextEditorTextWithReplacements,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorTextWithReplacements class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorTextWithReplacements class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void text_with_replacements_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorTextWithReplacements >> asArray [
	^ Array streamContents: [ :s |
		| next |
		[ next := self nextOrNil ]
			whileNotNil: [
				s nextPut: next ] ]
]

{ #category : #'as yet unclassified' }
GtTextEditorTextWithReplacements >> nextOrNil [
	| next |
	
	next := self primNext.
	next isNull ifTrue: [ ^ nil ].
	
	^ GtTextEditorTextOrReplacement
		fromNativeHandle: next
]

{ #category : #'as yet unclassified' }
GtTextEditorTextWithReplacements >> primNext [
	^ self ffiCall: #(void* text_with_replacements_next(self))
]
