Extension { #name : 'BlDoublePressToSelectAttribute' }

{ #category : '*GToolkit-Editor' }
BlDoublePressToSelectAttribute >> asGtExternalTextAttributeForTheme: aTheme during: aBlock [
	^ GtTextEditorAttribute
		doublePressToSelectTrimming: trimLeadingAndTrailingWhitespace
		onlyAtBoundary: onlyAtIntervalBoundaries
		during: aBlock
]
