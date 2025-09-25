Class {
	#name : #GtTextEditorTextOrReplacement,
	#superclass : #GtBoxerValueBox,
	#instVars : [
		'attribute'
	],
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void text_or_replacement_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement >> end [
	^ self primGetEnd
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement >> isReplacement [
	^ self primIsReplacement
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement >> isText [
	^ self primIsText
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement >> kindName [
	self isText
		ifTrue: [ ^ 'Text' ].
		
	self isReplacement
		ifTrue: [ ^ 'Replacement' ].
		
	^ 'Unknown'
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement >> primGetEnd [
	^ self ffiCall: #(size_t text_or_replacement_end(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement >> primGetStart [
	^ self ffiCall: #(size_t text_or_replacement_start(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement >> primIsReplacement [
	^ self ffiCall: #(bool text_or_replacement_is_replacement(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement >> primIsText [
	^ self ffiCall: #(bool text_or_replacement_is_text(self))
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement >> range [
	^ GtTextEditorTextRange start: self start end: self end
]

{ #category : #'as yet unclassified' }
GtTextEditorTextOrReplacement >> start [
	^ self primGetStart
]
