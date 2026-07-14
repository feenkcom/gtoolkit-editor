Extension { #name : 'BrTextAdornmentAttribute' }

{ #category : '*GToolkit-Editor' }
BrTextAdornmentAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	self shouldAppend
		ifTrue: [ ^ GtTextEditorAppendingAttribute newDuring: [ :attribute |
			self gtExternalTextConfigureAppendingAttribute: attribute.
			aBlock value: attribute ] ].
			
	self shouldReplace
		ifTrue: [ ^ GtTextEditorReplacingAttribute newDuring: [ :attribute |
			aBlock value: attribute ] ].

	self error: 'TODO'
]

{ #category : '*GToolkit-Editor' }
BrTextAdornmentAttribute >> gtEditorCreateExternalTextAttributeTagged: anAttributeTag registry: anAttributesRegistry forTheme: aTheme during: aBlock [
	self shouldAppend
		ifTrue: [ ^ GtTextEditorAppendingAttribute newWithTag: anAttributeTag during:  [ :attribute |
			self gtExternalTextConfigureAppendingAttribute: attribute.
			aBlock value: attribute ] ].
			
	self shouldReplace
		ifTrue: [ ^ GtTextEditorReplacingAttribute newWithTag: anAttributeTag during: [ :attribute |
			aBlock value: attribute ] ].

	self error: 'TODO'
]

{ #category : '*GToolkit-Editor' }
BrTextAdornmentAttribute >> gtEditorShouldBeAddedToRegistry [
	^ true
]

{ #category : '*GToolkit-Editor' }
BrTextAdornmentAttribute >> gtExternalTextConfigureAppendingAttribute: anAttribute [
	anAttribute setOverwritableByStyler: self isOverwritableByStyler
]
