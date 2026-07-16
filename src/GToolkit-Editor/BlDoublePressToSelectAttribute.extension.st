Extension { #name : 'BlDoublePressToSelectAttribute' }

{ #category : '*GToolkit-Editor' }
BlDoublePressToSelectAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute
		doublePressToSelectTrimming: trimLeadingAndTrailingWhitespace
		onlyAtBoundary: onlyAtIntervalBoundaries
		during: aBlock
]
