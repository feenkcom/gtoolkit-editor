Class {
	#name : 'GtTextEditorReplacementRuns',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'as yet unclassified' }
GtTextEditorReplacementRuns class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorReplacementRuns class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void replacement_runs_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorReplacementRuns >> asArray [
	^ Array streamContents: [ :s |
		| next |
		[ next := self nextOrNil ]
			whileNotNil: [
				s nextPut: next ] ]
]

{ #category : 'as yet unclassified' }
GtTextEditorReplacementRuns >> nextOrNil [
	| next |
	
	next := self primNext.
	next isNull ifTrue: [ ^ nil ].
	
	^ GtTextEditorExternalReplacementRun
		fromNativeHandle: next
		during: [ :run | 
			GtTextEditorReplacementRun new
				start: run start;
				end: run end;
				attribute: run takeAttribute ]
]

{ #category : 'as yet unclassified' }
GtTextEditorReplacementRuns >> primNext [
	^ self ffiCall: #(void* replacement_runs_next(self))
]
