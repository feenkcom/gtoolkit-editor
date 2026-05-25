Extension { #name : 'GtTextFolderAttributeV2' }

{ #category : '*GToolkit-Editor' }
GtTextFolderAttributeV2 >> gtExternalTextConfigureAppendingAttribute: anAttribute [
	super gtExternalTextConfigureAppendingAttribute: anAttribute.
	
	anAttribute beExactWidth: 15.
	anAttribute beExactHeight: 15.
]
