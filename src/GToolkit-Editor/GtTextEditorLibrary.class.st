Class {
	#name : 'GtTextEditorLibrary',
	#superclass : 'FFILibrary',
	#traits : 'TGtWithStringBox + TGtWithPointBoxF32 + TGtWithPhlowRust',
	#classTraits : 'TGtWithStringBox classTrait + TGtWithPointBoxF32 classTrait + TGtWithPhlowRust classTrait',
	#category : 'GToolkit-Editor-Library',
	#package : 'GToolkit-Editor',
	#tag : 'Library'
}

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

{ #category : 'accessing - platform' }
GtTextEditorLibrary >> macLibraryName [
	^ FFIMacLibraryFinder findLibrary: 'libEditor.dylib'
]

{ #category : 'private - ffi' }
GtTextEditorLibrary >> primTest [
	^ self ffiCall: #(bool editor_test())
]

{ #category : 'accessing - platform' }
GtTextEditorLibrary >> win32LibraryName [
	^ FFIWindowsLibraryFinder findLibrary: 'Editor.dll'
]
