Class {
	#name : #GtTextEditorLibrary,
	#superclass : #FFILibrary,
	#traits : 'TGtWithStringBox',
	#classTraits : 'TGtWithStringBox classTrait',
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorLibrary >> macLibraryName [
	^ FFIMacLibraryFinder findLibrary: 'libEditor.dylib'
]
