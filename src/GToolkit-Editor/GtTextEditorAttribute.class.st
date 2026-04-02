Class {
	#name : 'GtTextEditorAttribute',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'library path' }
GtTextEditorAttribute class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'instance creation' }
GtTextEditorAttribute class >> fontFamily: aFontFamilyName during: aBlock [
	^ self ffiLibrary
		newString: aFontFamilyName
		during: [ :aStringBox | 
			GtTextEditorAttribute
				fromNativeHandle: (self primFontFamily: aStringBox)
				during: aBlock ]
]

{ #category : 'instance creation' }
GtTextEditorAttribute class >> fontSize: aFontSize during: aBlock [
	^ GtTextEditorAttribute
		fromNativeHandle: (self primFontSize: aFontSize)
		during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorAttribute class >> fontWeight: aFontWeight during: aBlock [
	^ GtTextEditorAttribute
		fromNativeHandle: (self primFontWeight: aFontWeight)
		during: aBlock
]

{ #category : 'instance creation' }
GtTextEditorAttribute class >> foreground: aColor during: aBlock [
	^ GtTextEditorAttribute
		fromNativeHandle: (self
				primForegroundRed: aColor red
				green: aColor green
				blue: aColor blue
				alpha: aColor alpha)
		during: aBlock
]

{ #category : 'private - ffi' }
GtTextEditorAttribute class >> primFontFamily: aStringBox [
	^ self ffiCall: #(void* font_family_attribute_new(void* aStringBox))
]

{ #category : 'private - ffi' }
GtTextEditorAttribute class >> primFontSize: aFontSize [
	^ self ffiCall: #(void* font_size_attribute_new(float32 aFontSize))
]

{ #category : 'private - ffi' }
GtTextEditorAttribute class >> primFontWeight: aFontWeight [
	^ self ffiCall: #(void* font_weight_attribute_new(size_t aFontWeight))
]

{ #category : 'private - ffi' }
GtTextEditorAttribute class >> primForegroundRed: red green: green blue: blue alpha: alpha [
	^ self ffiCall: #(void* text_foreground_attribute_new(
		float32 red,
		float32 green,
		float32 blue,
		float32 alpha))
]

{ #category : 'private - ffi' }
GtTextEditorAttribute class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void attribute_release(void* aHandle))
]

{ #category : 'converting' }
GtTextEditorAttribute >> asAttribute [
	self class = GtTextEditorAttribute
		ifTrue: [ ^ self ].
		
	^ GtTextEditorAttribute fromNativeHandle: self primAsAttribute
]

{ #category : 'converting' }
GtTextEditorAttribute >> asGtExternalTextAttributeDuring: aBlock [
	self class = GtTextEditorAttribute
		ifTrue: [ ^ aBlock value: self ].
	
	^ GtTextEditorAttribute
		fromNativeHandle: self primAsAttribute
		during: aBlock
]

{ #category : 'accessing' }
GtTextEditorAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	^ self asGtExternalTextAttributeDuring: aBlock
]

{ #category : 'testing' }
GtTextEditorAttribute >> isAdornmentAttribute [
	^ false
]

{ #category : 'testing' }
GtTextEditorAttribute >> isMarkerAttribute [
	^ false
]

{ #category : 'private - ffi' }
GtTextEditorAttribute >> primAsAttribute [
	self subclassResponsibility.

	"self ffiCall: #(void* replacing_attribute_into_attribute(self))"
]
