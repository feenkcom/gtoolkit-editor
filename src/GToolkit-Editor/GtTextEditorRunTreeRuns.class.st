Class {
	#name : #GtTextEditorRunTreeRuns,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorRunTreeRuns class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTreeRuns class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void run_tree_runs_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTreeRuns >> asArray [
	^ Array streamContents: [ :s |
		| next |
		[ next := self nextOrNil ]
			whileNotNil: [
				s nextPut: next ] ]
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTreeRuns >> nextOrNil [
	| next |
	
	next := self primNext.
	next isNull ifTrue: [ ^ nil ].
	
	^ GtTextEditorExternalRunTreeRun
		fromNativeHandle: next
		during: [ :run | 
			GtTextEditorRunTreeRun new
				start: run start;
				end: run end ]
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTreeRuns >> primNext [
	^ self ffiCall: #(void* run_tree_runs_next(self))
]
