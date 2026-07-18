Extension { #name : 'BrTextAdornmentTextAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextAdornmentTextAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ text
		asGtTextEditorText: anAttributesRegistry
		forTheme: aTheme
		during: [ :anExternalText | 
			self shouldAppend
				ifTrue: [ ^ GtTextEditorAppendingAttribute
						appendingText: anExternalText
						during: [ :anExternalAttribute | 
							self gtExternalTextConfigureAppendingAttribute: anExternalAttribute.
							aBlock value: anExternalAttribute ] ].

			self shouldReplace
				ifTrue: [ ^ GtTextEditorReplacingAttribute replacingText: anExternalText during: aBlock ] ]
]

{ #category : '*GToolkit-Editor' }
BrTextAdornmentTextAttribute >> gtEditorCreateExternalTextAttributeTagged: anAttributeTag registry: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ text
		asGtTextEditorText: anAttributesRegistry
		forTheme: aTheme
		during: [ :anExternalText | 
			self shouldAppend
				ifTrue: [ ^ GtTextEditorAppendingAttribute
						appendingText: anExternalText
						withTag: anAttributeTag
						during: [ :anExternalAttribute | 
							self gtExternalTextConfigureAppendingAttribute: anExternalAttribute.
							aBlock value: anExternalAttribute ] ].

			self shouldReplace
				ifTrue: [ ^ GtTextEditorReplacingAttribute
						replacingText: anExternalText
						withTag: anAttributeTag
						during: aBlock ] ]
]
