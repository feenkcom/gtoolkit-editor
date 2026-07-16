Extension { #name : 'BrTextAdornmentTextAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextAdornmentTextAttribute >> gtEditorAsExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
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

			self shouldReplace ifTrue: [ self shouldBeImplemented ] ]
]
