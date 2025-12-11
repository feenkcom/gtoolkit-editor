Class {
	#name : 'GtTextEditorExternalMethods',
	#superclass : 'Object',
	#instVars : [
		'offsetFn',
		'payloadCloneFn',
		'payloadFreeFn',
		'drawFn',
		'session'
	],
	#classVars : [
		'Current'
	],
	#category : 'GToolkit-Editor-Model',
	#package : 'GToolkit-Editor',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
GtTextEditorExternalMethods class >> current [
	^ Current
		lock: [ :instance | 
			instance session = Smalltalk session
				ifTrue: [ instance ]
				ifFalse: [ | newInstance |
					newInstance := self new.
					Current value: newInstance.
					newInstance ] ]
		ifNilPut: [ self new ]
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalMethods class >> initialize [
	Current := AsyncMutex new
]

{ #category : 'accessing' }
GtTextEditorExternalMethods >> drawFn [
	^ drawFn
]

{ #category : 'as yet unclassified' }
GtTextEditorExternalMethods >> initialize [
	| library |
	super initialize.
	
	library := GtTextEditorLibrary uniqueInstance libraryName.
	
	drawFn := FFIBackend current
			loadSymbol: #editor_draw
			module: library.

	offsetFn := FFIBackend current
			loadSymbol: #adornment_dynamic_offset_payload_get_offset
			module: library.

	payloadCloneFn := FFIBackend current
			loadSymbol: #adornment_dynamic_offset_payload_clone
			module: library.

	payloadFreeFn := FFIBackend current
			loadSymbol: #adornment_dynamic_offset_payload_release
			module: library.
			
	session := Smalltalk session
]

{ #category : 'accessing' }
GtTextEditorExternalMethods >> offsetFn [
	^ offsetFn
]

{ #category : 'accessing' }
GtTextEditorExternalMethods >> payloadCloneFn [
	^ payloadCloneFn
]

{ #category : 'accessing' }
GtTextEditorExternalMethods >> payloadFreeFn [
	^ payloadFreeFn
]

{ #category : 'accessing' }
GtTextEditorExternalMethods >> session [
	^ session
]
