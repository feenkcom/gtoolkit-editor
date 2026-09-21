"
I install the fonts that Glamorous Toolkit bundles into the Rust editor's font registry.

Without me a Rust editor resolves font family names only against the operating system's fonts, so a family such as 'Source Code Pro' renders correctly only if it happens to be installed system-wide, and silently falls back to some other font otherwise. Bloc does not have this problem because `BrGlamorousFonts` registers the bundled faces directly on the Sparta canvas; I do the equivalent for Rust.

I read the faces from `BrGlamorousFonts class>>#fontSpecifications`, so the bundled fonts are described in exactly one place and cannot drift between the Bloc and the Rust side.

!! When I run

I install on image startup, through the session manager, because that is the lifetime the Rust registry actually has: the registry lives in the native library, so a new session always starts with it empty. Installing later - when an editor is created, say - would be both too late for editors that have already laid out text, and would force every running editor thread to rebuild its font collection.

Installing is cheap and idempotent, so running me more than once is harmless.
"
Class {
	#name : 'GtTextEditorFonts',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Library',
	#package : 'GToolkit-Editor',
	#tag : 'Library'
}

{ #category : 'installing' }
GtTextEditorFonts class >> basicInstallFonts [
	"Install every bundled font face, letting errors propagate. See installFonts.
	I depend on no other startup handler having run: each specification reads its bytes on
	demand through BrGlamorousFonts, which loads and memoizes them itself."
	| library |
	library := self library.
	library hasModule
		ifFalse: [ ^ self ].
	self fontSpecifications do: [ :eachSpecification |
		library
			registerFontFamilyNamed: eachSpecification familyName
			weight: eachSpecification weight
			emphasis: eachSpecification emphasisCode
			bytes: eachSpecification bytes ]
]

{ #category : 'accessing' }
GtTextEditorFonts class >> fontSpecifications [
	"Answer the font faces to install. They come from BrGlamorousFonts, which is the single
	place the bundled fonts are described, shared with the Bloc side."
	<return: #Array of: #BrGlamorousFontSpecification>
	^ BrGlamorousFonts fontSpecifications
]

{ #category : 'class initialization' }
GtTextEditorFonts class >> initialize [
	SessionManager default registerUserClassNamed: self name
]

{ #category : 'installing' }
GtTextEditorFonts class >> installFonts [
	"Install every bundled font face into the Rust editor's font registry.
	Failures are reported but never raised: a missing or incompatible native library must not
	stop the image from starting."
	<script: 'self installFonts'>
	[ self basicInstallFonts ]
		on: Error
		do: [ :anError |
			NonInteractiveTranscript stderr
				nextPutAll: 'Failed to install fonts into Rust editors. ';
				nextPutAll: anError description;
				cr ]
]

{ #category : 'accessing' }
GtTextEditorFonts class >> library [
	<return: #GtTextEditorLibrary>
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'system startup' }
GtTextEditorFonts class >> startUp: isImageStarting [
	"The Rust font registry lives in the native library, so every new session starts with it
	empty and has to be filled again. That is exactly the lifetime a startup hook has."
	isImageStarting
		ifTrue: [ self installFonts ]
]
