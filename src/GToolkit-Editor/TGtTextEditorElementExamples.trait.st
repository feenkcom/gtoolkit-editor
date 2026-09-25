Trait {
	#name : 'TGtTextEditorElementExamples',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'support' }
TGtTextEditorElementExamples >> ifLibEditorExamplesCannotBeExecutedDo: aBlock [
	^ GtTextEditorLibrary canRunExamples ifTrue: [ nil ] ifFalse: aBlock
]
