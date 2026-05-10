Class {
	#name : 'GtTextEditorLibrary',
	#superclass : 'FFILibrary',
	#traits : 'TGtWithStringBox + TGtWithPointBoxF32 + TGtWithPhlowRust',
	#classTraits : 'TGtWithStringBox classTrait + TGtWithPointBoxF32 classTrait + TGtWithPhlowRust classTrait',
	#category : 'GToolkit-Editor-Library',
	#package : 'GToolkit-Editor',
	#tag : 'Library'
}

{ #category : 'logger' }
GtTextEditorLibrary class >> initEnvLogger [
	self uniqueInstance initEnvLogger
]

{ #category : 'class initialization' }
GtTextEditorLibrary class >> initialize [
	SessionManager default registerUserClassNamed: self name
]

{ #category : 'system startup' }
GtTextEditorLibrary class >> startUp: isANewSession [
	isANewSession
		ifTrue: [ self initEnvLogger ]
]

{ #category : 'testing' }
GtTextEditorLibrary >> hasModule [
	"Return if there is a loadable and working Skia library installed, false otherwise"
	<return: #Boolean>
	| aResult |

	aResult := nil.
	
	[ aResult := self primTest ]
		on: Error
		do: [ :e | 
			NonInteractiveTranscript stderr nextPutAll: e description; cr.
			aResult := false ].

	^ aResult ifNil: [ false ]
]

{ #category : 'logger' }
GtTextEditorLibrary >> initEnvLogger [
	[ self primInitEnvLogger ]
		on: Error
		do: [ :e | NonInteractiveTranscript stdout nextPutAll: '[Editor] Could not init env logger'; cr ]
]

{ #category : 'accessing - platform' }
GtTextEditorLibrary >> macLibraryName [
	^ FFIMacLibraryFinder findLibrary: 'libEditor.dylib'
]

{ #category : 'private - ffi' }
GtTextEditorLibrary >> primInitEnvLogger [
	^ self ffiCall: #(void editor_init_logger())
]

{ #category : 'private - ffi' }
GtTextEditorLibrary >> primTest [
	^ self ffiCall: #(bool editor_test())
]

{ #category : 'accessing - platform' }
GtTextEditorLibrary >> unix32LibraryName [
	"Note: we currently do not support (build) library for Linux."

	^ FFIMacLibraryFinder findLibrary: 'libEditor.so'
]

{ #category : 'accessing - platform' }
GtTextEditorLibrary >> unix64LibraryName [
	"Note: we currently do not support (build) library for Linux."

	^ FFIMacLibraryFinder findLibrary: 'libEditor.so'
]

{ #category : 'accessing - platform' }
GtTextEditorLibrary >> win32LibraryName [
	^ FFIWindowsLibraryFinder findLibrary: 'Editor.dll'
]
