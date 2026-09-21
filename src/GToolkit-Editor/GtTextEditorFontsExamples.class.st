"
I exemplify that the fonts {{gtClass:GtTextEditorFonts}} installs are genuinely used when a Rust editor lays text out.

## Why the obvious check would prove nothing

Asking a Rust editor to use `'Source Code Pro'` and observing that it renders *something* is not evidence. Skia answers every family name with some typeface: an unknown family falls back to a system font, and once any custom font is registered an unknown family falls back to one of those instead. A test that merely sets a family and sees text would pass just as happily with the registry empty.

## What I assert instead

I compare two bundled families that have different metrics, and I use a property that no fallback can accidentally satisfy.

- *Source Code Pro* is monospace. Two strings of the same length, one of narrow glyphs and one of wide ones, must wrap identically and so must measure to the same height. That is true only if a real monospace font was used; the system fallback is proportional.
- *Source Sans Pro* is proportional, so the very same two strings must measure to clearly different heights.

Together these say that the alias resolved to the intended font, and that the two aliases did not collapse onto one fallback.

## How the measuring works

Height is the only layout measurement a {{gtClass:GtTextEditorHandle}} exposes to Smalltalk, so I measure at a fixed width and read how far the text wrapped. Measuring is asynchronous - the command travels to the editor thread - so I poll briefly for the result rather than reading it straight away.
"
Class {
	#name : 'GtTextEditorFontsExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Library',
	#package : 'GToolkit-Editor',
	#tag : 'Library'
}

{ #category : 'accessing - parameters' }
GtTextEditorFontsExamples >> characterCount [
	^ 200
]

{ #category : 'accessing - parameters' }
GtTextEditorFontsExamples >> fontSize [
	^ 20
]

{ #category : 'examples' }
GtTextEditorFontsExamples >> fontsAreInstalled [
	"Installing is idempotent, so running me is safe even though the fonts were already
	installed at image startup."
	<gtExample>
	<return: #Array>
	| specifications |
	GtTextEditorFonts installFonts.
	specifications := BrGlamorousFonts fontSpecifications.
	self assert: specifications notEmpty.
	self
		assert: (specifications anySatisfy: [ :each | each familyName = 'Source Code Pro' ]).
	self
		assert: (specifications anySatisfy: [ :each | each familyName = 'Source Sans Pro' ]).
	^ specifications
]

{ #category : 'private - measuring' }
GtTextEditorFontsExamples >> measuredHeightForFamily: aFamilyName text: aString [
	"Lay aString out in a Rust editor with aFamilyName as the default font family and answer the
	resulting height.

	Height is the only layout measurement the handle exposes to Smalltalk, so it stands in for
	glyph width: at a fixed width, wider glyphs wrap sooner and produce a taller result.

	Measuring is asynchronous - the command is handed to the editor thread - so the height is not
	available the instant the request returns. Poll briefly rather than reading immediately,
	and fail loudly if nothing ever arrives, because a height of zero would otherwise look like
	a legitimate measurement and make every comparison below vacuously true."
	| element handle polls height |
	element := GtTextEditorElement new.
	element text: aString asRopedText.
	handle := element privateEditorHandle.
	handle defaultFontSize: self fontSize.
	handle defaultFontName: aFamilyName.
	handle measureWidth: self measurementWidth top: nil height: nil.
	polls := 0.
	height := handle height.
	[ height = 0.0 and: [ polls < 200 ] ] whileTrue: [
		(Delay forMilliseconds: 10) wait.
		polls := polls + 1.
		height := handle height ].
	self
		assert: height > 0.0
		description: [ 'Measuring never completed for ' , aFamilyName printString ].
	^ height
]

{ #category : 'accessing - parameters' }
GtTextEditorFontsExamples >> measurementWidth [
	"The width every measurement is taken at. Narrow enough that 200 characters wrap many
	times, so a difference in glyph width shows up as a clear difference in height."
	^ 200.0
]

{ #category : 'accessing - parameters' }
GtTextEditorFontsExamples >> narrowText [
	"A run of the narrowest common glyph."
	^ String new: self characterCount withAll: $i
]

{ #category : 'examples' }
GtTextEditorFontsExamples >> sourceCodeProIsMonospace [
	"The decisive example: Source Code Pro is a monospace font, so equally long runs of a narrow
	and a wide glyph must wrap identically and measure to the same height.

	No fallback can satisfy this by accident. If the family did not resolve to the bundled font,
	the text would be laid out with a proportional system font and the two heights would differ,
	as sourceSansProIsProportional demonstrates with the very same strings."
	<gtExample>
	<return: #Array>
	| narrowHeight wideHeight |
	self fontsAreInstalled.
	narrowHeight := self
		measuredHeightForFamily: 'Source Code Pro'
		text: self narrowText.
	wideHeight := self measuredHeightForFamily: 'Source Code Pro' text: self wideText.
	self
		assert: narrowHeight = wideHeight
		description: [ 'Source Code Pro must be monospace, so narrow and wide glyphs must wrap '
			, 'identically. Got ' , narrowHeight printString , ' and ' , wideHeight printString
			, ', which means text was laid out with some other, proportional font.' ].
	^ { narrowHeight. wideHeight }
]

{ #category : 'examples' }
GtTextEditorFontsExamples >> sourceSansProIsProportional [
	"The counterpart: Source Sans Pro is proportional, so the same two strings must measure to
	clearly different heights.

	This is what rules out the possibility that both families quietly resolved to one and the
	same fallback font - in that case this example and sourceCodeProIsMonospace could not both
	pass, since they measure identical strings."
	<gtExample>
	<return: #Array>
	| narrowHeight wideHeight |
	self fontsAreInstalled.
	narrowHeight := self
		measuredHeightForFamily: 'Source Sans Pro'
		text: self narrowText.
	wideHeight := self measuredHeightForFamily: 'Source Sans Pro' text: self wideText.
	self
		assert: wideHeight > narrowHeight
		description: [ 'Source Sans Pro must be proportional, so a run of wide glyphs must wrap '
			, 'sooner than a run of narrow ones. Got ' , narrowHeight printString , ' and '
			, wideHeight printString ].
	^ { narrowHeight. wideHeight }
]

{ #category : 'examples' }
GtTextEditorFontsExamples >> theTwoBundledFamiliesLayOutDifferently [
	"The same text measured under both bundled families must give different results.

	If the registry were empty, both family names would be unknown, both would fall back to the
	same font, and these two heights would be equal."
	<gtExample>
	<return: #Array>
	| codeHeight sansHeight |
	self fontsAreInstalled.
	codeHeight := self measuredHeightForFamily: 'Source Code Pro' text: self wideText.
	sansHeight := self measuredHeightForFamily: 'Source Sans Pro' text: self wideText.
	self
		assert: codeHeight ~= sansHeight
		description: [ 'The two bundled families must lay the same text out differently. Both '
			, 'measured ' , codeHeight printString
			, ', which is what would happen if neither family resolved and both fell back to the '
			, 'same font.' ].
	^ { codeHeight. sansHeight }
]

{ #category : 'accessing - parameters' }
GtTextEditorFontsExamples >> wideText [
	"A run of the widest common glyph, the same length as narrowText."
	^ String new: self characterCount withAll: $M
]
