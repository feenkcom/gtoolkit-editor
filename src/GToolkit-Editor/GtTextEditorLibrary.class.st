Class {
	#name : 'GtTextEditorLibrary',
	#superclass : 'FFILibrary',
	#traits : 'TGtWithStringBox + TGtWithPointBoxF32 + TGtWithPhlowRust',
	#classTraits : 'TGtWithStringBox classTrait + TGtWithPointBoxF32 classTrait + TGtWithPhlowRust classTrait',
	#category : 'GToolkit-Editor-Library',
	#package : 'GToolkit-Editor',
	#tag : 'Library'
}

{ #category : 'as yet unclassified' }
GtTextEditorLibrary >> macLibraryName [
	^ FFIMacLibraryFinder findLibrary: 'libEditor.dylib'
]
