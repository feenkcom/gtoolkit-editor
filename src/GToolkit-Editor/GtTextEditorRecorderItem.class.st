Class {
	#name : 'GtTextEditorRecorderItem',
	#superclass : 'Object',
	#instVars : [
		'string',
		'fields'
	],
	#category : 'GToolkit-Editor-Debugging',
	#package : 'GToolkit-Editor',
	#tag : 'Debugging'
}

{ #category : 'initialization' }
GtTextEditorRecorderItem >> initialize [
	super initialize.
	string := String empty.
	fields := OrderedCollection new
]
