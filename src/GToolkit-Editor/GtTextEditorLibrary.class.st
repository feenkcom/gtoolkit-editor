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

{ #category : 'testing' }
GtTextEditorLibrary class >> isSupported [
	"Answer whether the Rust text editor can actually be used in this image.
	It is false when the native libEditor is not installed for this platform,
	or when the image has no windowing event loop, most notably a headless
	command-line image such as the one running examples on CI.

	The two conditions are independent:

	1. `hasModule` is false when the native library cannot be located or loaded:
	  - the GT distribution for this platform does not ship libEditor
	    (for example libEditor.so is currently missing on the Linux CI agents);
	  - the application bundle is incomplete, or the library was moved or removed;
	  - the library exists but the OS refuses to load it, for example a wrong
	    architecture, a missing transitive dependency, or a signing restriction.

	2. `RustWindowingEventFetcher default` is nil when no windowing event fetcher
	  is available for this image, because no concrete fetcher answers
	  `isAvailable`. For `Winit30WorkerThreadEventFetcher` that happens when:
	  - the image is headless and was not started with `--interactive`, which is
	    the case for `GlamorousToolkit-cli` running examples and tests;
	  - the VM does not run the image in a worker thread;
	  - the VM is headful, meaning the UI is managed by the VM and winit is unused;
	  - the winit library itself is not installed.

	Sending this message is cheap: it may instantiate the event fetcher singleton,
	but it does not start the winit event loop, which stays lazy until the first
	window is created."

	^ self uniqueInstance hasModule
		and: [ RustWindowingEventFetcher default notNil ]
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
		do: [ :e | "explicitly ignore it, because the library is optional" ]
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
