"
{{gtClass:GtTextualCoderElement}} uses completion controller that has {{gtClass:GtCompletionStrategy}}. This controller passes the strategy to the {{gtClass:GtTextEditorElement}}. 

Note: we want to remove the {{gtClass:GtCompletionController}} and put the logic dirrectly to the {{gtClass:BrEditor}}. Once it is done, we can remove this class.
"
Class {
	#name : 'GtCompletionForwardingController',
	#superclass : 'Object',
	#instVars : [
		'editorElement'
	],
	#category : 'GToolkit-Editor-Completion',
	#package : 'GToolkit-Editor',
	#tag : 'Completion'
}

{ #category : 'accessing' }
GtCompletionForwardingController >> editorElement [
	^ editorElement
]

{ #category : 'accessing' }
GtCompletionForwardingController >> editorElement: anObject [
	editorElement := anObject
]

{ #category : 'api - initialization' }
GtCompletionForwardingController >> install [
	"do nothing"

	
]

{ #category : 'accessing' }
GtCompletionForwardingController >> strategy: aGtCompletionStrategy [
	self editorElement completionStrategy: aGtCompletionStrategy
]

{ #category : 'api - initialization' }
GtCompletionForwardingController >> uninstall [
	"do nothing"

	
]
