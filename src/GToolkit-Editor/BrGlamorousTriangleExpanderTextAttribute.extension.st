Extension { #name : 'BrGlamorousTriangleExpanderTextAttribute' }

{ #category : '*GToolkit-Editor' }
BrGlamorousTriangleExpanderTextAttribute >> gtExternalTextConfigureAppendingAttribute: anAttribute [
	super gtExternalTextConfigureAppendingAttribute: anAttribute.
	
	"doesn't quite work yet, attributes don't appear because editor element doesn't receive measurement announcement"
	self flag: #TODO. 
	
	"anAttribute beExactWidth: 16.
	anAttribute beExactHeight: 16."
]
