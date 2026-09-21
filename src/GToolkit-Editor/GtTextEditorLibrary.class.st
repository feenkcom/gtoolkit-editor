Class {
	#name : 'GtTextEditorLibrary',
	#superclass : 'FFILibrary',
	#traits : 'TGtWithStringBox + TGtWithPointBoxF32 + TGtWithPhlowRust + TGtWithArrayBoxU8',
	#classTraits : 'TGtWithStringBox classTrait + TGtWithPointBoxF32 classTrait + TGtWithPhlowRust classTrait + TGtWithArrayBoxU8 classTrait',
	#category : 'GToolkit-Editor-Library',
	#package : 'GToolkit-Editor',
	#tag : 'Library'
}

{ #category : 'testing' }
GtTextEditorLibrary class >> canRunExamples [
	"Answer whether an example that needs the Rust text editor can really run in this
	image, and report on stdout when it cannot.

	Examples guarded by this method return early, so they are reported as successful
	although nothing was exercised. In the JUnit report that is indistinguishable from
	a real pass, which is why the reason is written to stdout: the CI console log is
	the only place where the difference is visible. Grep a build log for
	`LIB-EDITOR-EXAMPLE-SKIPPED` to see which agents actually exercised the editor,
	and which silently skipped it.

	The two halves of the message are diagnosed separately, because they mean very
	different things. A missing libEditor is a packaging problem: the library was not
	shipped to that platform, or cannot be loaded there. A missing windowing event loop
	is expected whenever the image runs headless without `--interactive`, which is how
	`GlamorousToolkit-cli` runs examples on CI. See `isSupported` for the full set of
	conditions behind each one.

	The platform and architecture are included because all CI agents write into a
	single interleaved console log, and are otherwise impossible to tell apart."

	| hasLibrary hasEventLoop |
	hasLibrary := self uniqueInstance hasModule.
	hasEventLoop := RustWindowingEventFetcher default notNil.
	(hasLibrary and: [ hasEventLoop ]) ifTrue: [ ^ true ].

	NonInteractiveTranscript stdout
		nextPutAll: ' (LIB-EDITOR-EXAMPLE-SKIPPED';
		nextPutAll: ' on ';
		nextPutAll: Smalltalk os name;
		nextPutAll: '/';
		nextPutAll: Smalltalk vm architectureName;
		nextPutAll: ', libEditor: ';
		nextPutAll: (hasLibrary
				ifTrue: [ 'installed' ]
				ifFalse: [ 'NOT INSTALLED' ]);
		nextPutAll: ', windowing event loop: ';
		nextPutAll: (hasEventLoop
				ifTrue: [ 'available' ]
				ifFalse: [ 'NOT AVAILABLE (headless image?)' ]);
		nextPutAll: ', the example is reported as successful without being executed) '.
	^ false
]

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

{ #category : 'primitives - fonts' }
GtTextEditorLibrary >> primRegisterFontFamily: aGtStringBox weight: aWeight emphasis: anEmphasis bytes: aGtArrayBoxU8 [
	"Register one font face in the Rust editor's process-wide font registry, so that every Rust
	editor can resolve that family by name instead of falling back to an OS font.
	See font_registry_register_font in libeditor.
	Emphasis is 0 normal, 1 italic, 2 oblique, matching SpartaFontSlant's own values."
	^ self ffiCall: #(void font_registry_register_font(
		GtStringBox aGtStringBox,
		int32 aWeight,
		int32 anEmphasis,
		GtArrayBoxU8 aGtArrayBoxU8))
]

{ #category : 'private - ffi' }
GtTextEditorLibrary >> primTest [
	^ self ffiCall: #(bool editor_test())
]

{ #category : 'fonts' }
GtTextEditorLibrary >> registerFontFamilyNamed: aFamilyName weight: aWeight emphasis: anEmphasis bytes: aByteArray [
	"Register one font face from a family name and the raw contents of a font file.
	Both boxes live only for the duration of the call: Rust copies the bytes immediately,
	so there is no cross-FFI lifetime to manage.
	Registration is idempotent - registering the same family, weight and emphasis again with
	the same bytes does nothing."
	^ self
		newString: aFamilyName
		during: [ :aStringBox |
			self
				newArrayU8FromByteArray: aByteArray
				during: [ :anArrayBox |
					self
						primRegisterFontFamily: aStringBox
						weight: aWeight
						emphasis: anEmphasis
						bytes: anArrayBox ] ]
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
