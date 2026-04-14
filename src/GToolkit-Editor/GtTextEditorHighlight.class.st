Class {
	#name : 'GtTextEditorHighlight',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'library path' }
GtTextEditorHighlight class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'instance creation' }
GtTextEditorHighlight class >> id: aString color: aColor during: aBlock [
	^ self ffiLibrary
		newString: aString asString
		during: [ :aStringBox | 
			self
				fromNativeHandle: (self
						primNewId: aStringBox
						r: aColor red
						g: aColor green
						b: aColor blue
						a: aColor alpha)
				during: aBlock ]
]

{ #category : 'private - ffi' }
GtTextEditorHighlight class >> primNewId: aStringBox r: red g: green b: blue a: alpha [
	^ self ffiCall: #(void* highlight_new(
		void* aStringBox,
		float32 red,
		float32 green,
		float32 blue,
		float32 alpha))
]

{ #category : 'private - ffi' }
GtTextEditorHighlight class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void highlight_release(void* aHandle))
]
