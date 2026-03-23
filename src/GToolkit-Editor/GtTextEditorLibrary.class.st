Class {
	#name : 'GtTextEditorLibrary',
	#superclass : 'FFILibrary',
	#traits : 'TGtWithStringBox + TGtWithPointBoxF32 + TGtWithPhlowRust',
	#classTraits : 'TGtWithStringBox classTrait + TGtWithPointBoxF32 classTrait + TGtWithPhlowRust classTrait',
	#category : 'GToolkit-Editor-Model',
	#package : 'GToolkit-Editor',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
GtTextEditorLibrary >> macLibraryName [
	^ FFIMacLibraryFinder findLibrary: 'libEditor.dylib'
]
