Class {
	#name : 'GtTextEditorTextAroundByteOffset',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'as yet unclassified' }
GtTextEditorTextAroundByteOffset class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'as yet unclassified' }
GtTextEditorTextAroundByteOffset class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void text_around_byte_offset_release(void* aHandle))
]

{ #category : 'as yet unclassified' }
GtTextEditorTextAroundByteOffset >> byteOffsetCharIndex [
	^ self primByteOffsetCharIndex
]

{ #category : 'as yet unclassified' }
GtTextEditorTextAroundByteOffset >> lineEndOffset [
	^ self primGetLineEndOffset
]

{ #category : 'as yet unclassified' }
GtTextEditorTextAroundByteOffset >> lineStartOffset [
	^ self primGetLineStartOffset
]

{ #category : 'as yet unclassified' }
GtTextEditorTextAroundByteOffset >> primByteOffsetCharIndex [
	^ self ffiCall: #(size_t text_around_byte_offset_get_byte_offset_char_index(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorTextAroundByteOffset >> primGetLineEndOffset [
	^ self ffiCall: #(size_t text_around_byte_offset_get_line_end_offset(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorTextAroundByteOffset >> primGetLineStartOffset [
	^ self ffiCall: #(size_t text_around_byte_offset_get_line_start_offset(self))
]

{ #category : 'as yet unclassified' }
GtTextEditorTextAroundByteOffset >> primGetString: aStringBox [
	^ self ffiCall: #(void text_around_byte_offset_get_string(self, void* aStringBox))
]

{ #category : 'as yet unclassified' }
GtTextEditorTextAroundByteOffset >> string [
	^ self ffiLibrary
		getStringFrom: [ :aStringBox | self primGetString: aStringBox ]
]
