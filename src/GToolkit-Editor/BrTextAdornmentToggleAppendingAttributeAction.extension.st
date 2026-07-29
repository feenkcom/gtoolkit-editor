Extension { #name : 'BrTextAdornmentToggleAppendingAttributeAction' }

{ #category : '*GToolkit-Editor' }
BrTextAdornmentToggleAppendingAttributeAction >> gtEditorConfigureAppendingAttribute: aRustAppendingAttribute attributesRegistry: anAttributesRegistry forTheme: aTheme [

	appendingAttribute
		gtEditorAsExternalTextAttribute: anAttributesRegistry
		forTheme: aTheme
		during: [ :anExternalAttribute | aRustAppendingAttribute setToggleAppendingAttributeAction: anExternalAttribute ]
]
