Extension { #name : 'BrGlamorousTriangleExpanderTextAttribute' }

{ #category : '*GToolkit-Editor' }
BrGlamorousTriangleExpanderTextAttribute >> gtExternalTextConfigureAppendingAttribute: anAttribute [
	super gtExternalTextConfigureAppendingAttribute: anAttribute.
	
	anAttribute beExactWidth: 16.
	anAttribute beExactHeight: 16.
]
