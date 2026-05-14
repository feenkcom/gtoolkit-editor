Class {
	#name : 'GtTextEditorLineBreakStyle',
	#superclass : 'GtExternalEnumeration',
	#classVars : [
		'Auto',
		'Cr',
		'CrLf',
		'Lf'
	],
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'accessing enum' }
GtTextEditorLineBreakStyle class >> Auto [
	"This method was automatically generated"
	^ Auto
]

{ #category : 'accessing enum' }
GtTextEditorLineBreakStyle class >> Cr [
	"This method was automatically generated"
	^ Cr
]

{ #category : 'accessing enum' }
GtTextEditorLineBreakStyle class >> CrLf [
	"This method was automatically generated"
	^ CrLf
]

{ #category : 'accessing enum' }
GtTextEditorLineBreakStyle class >> Lf [
	"This method was automatically generated"
	^ Lf
]

{ #category : 'enum declaration' }
GtTextEditorLineBreakStyle class >> externalDeclaration [
	"self rebuildEnumAccessors"
	
	^ #(
		Auto,
    Cr,
    Lf,
    CrLf
	)
]

{ #category : 'enum declaration' }
GtTextEditorLineBreakStyle class >> externalType [
	^ FFIUInt8 new
]

{ #category : 'as yet unclassified' }
GtTextEditorLineBreakStyle class >> initialize [
	super initialize
]
