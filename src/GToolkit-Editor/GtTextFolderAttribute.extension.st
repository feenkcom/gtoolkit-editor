Extension { #name : 'GtTextFolderAttribute' }

{ #category : '*GToolkit-Editor' }
GtTextFolderAttribute >> gtExternalTextConfigureAppendingAttribute: anAttribute [
	super gtExternalTextConfigureAppendingAttribute: anAttribute.
	
	anAttribute beExactWidth: 15.
	anAttribute beExactHeight: 15.
]
