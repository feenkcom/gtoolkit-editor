Class {
	#name : 'GtTextEditorExternalReplacementRun',
	#superclass : 'GtBoxerValueBox',
	#instVars : [
		'attribute'
	],
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'as yet unclassified' }
GtTextEditorExternalReplacementRun class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalReplacementRun class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void replacement_run_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalReplacementRun >> end [
	^ self primGetEnd
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalReplacementRun >> primGetEnd [
	^ self ffiCall: #(size_t replacement_run_get_end(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalReplacementRun >> primGetStart [
	^ self ffiCall: #(size_t replacement_run_get_start(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalReplacementRun >> primTakeAttribute [
	^ self ffiCall: #(void* replacement_run_take_attribute(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalReplacementRun >> start [
	^ self primGetStart
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalReplacementRun >> takeAttribute [
	^ GtTextEditorAdornmentAttribute fromNativeHandle: self primTakeAttribute
]
