Class {
	#name : 'GtTextEditorExternalRunTreeRun',
	#superclass : 'GtBoxerValueBox',
	#instVars : [
		'attribute'
	],
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'as yet unclassified' }
GtTextEditorExternalRunTreeRun class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalRunTreeRun class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void run_tree_run_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalRunTreeRun >> end [
	^ self primGetEnd
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalRunTreeRun >> primGetEnd [
	^ self ffiCall: #(size_t run_tree_run_get_end(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalRunTreeRun >> primGetStart [
	^ self ffiCall: #(size_t run_tree_run_get_start(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalRunTreeRun >> start [
	^ self primGetStart
]
