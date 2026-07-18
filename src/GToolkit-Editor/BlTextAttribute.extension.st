Extension { #name : 'BlTextAttribute' }

{ #category : '*GToolkit-Editor' }
BlTextAttribute >> gtEditorAsExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ self gtEditorShouldBeAddedToRegistry
		ifTrue: [ anAttributesRegistry
				findAttributeTag: self
				ifFound: [ :anExistingTag | 
					self
						gtEditorCreateExternalTextAttributeTagged: anExistingTag
						registry: anAttributesRegistry
						forTheme: aTheme
						during: [ :aTypedExternalAttribute | 
							aTypedExternalAttribute
								asGtExternalTextAttributeDuring: [ :anExternalAttribute | aBlock value: anExternalAttribute ] ] ]
				ifNone: [ self
						gtEditorCreateExternalTextAttribute: anAttributesRegistry
						forTheme: aTheme
						during: [ :aTypedExternalAttribute | 
							anAttributesRegistry
								registerAttribute: self
								attributeTag: aTypedExternalAttribute attributeTag.
							aTypedExternalAttribute
								asGtExternalTextAttributeDuring: [ :anExternalAttribute | aBlock value: anExternalAttribute ] ] ] ]
		ifFalse: [ self
				gtEditorCreateExternalTextAttribute: anAttributesRegistry
				forTheme: aTheme
				during: [ :aTypedExternalAttribute | 
					aTypedExternalAttribute
						asGtExternalTextAttributeDuring: [ :anExternalAttribute | aBlock value: anExternalAttribute ] ] ]
]

{ #category : '*GToolkit-Editor' }
BlTextAttribute >> gtEditorCreateExternalTextAttribute: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ self subclassResponsibility
]

{ #category : '*GToolkit-Editor' }
BlTextAttribute >> gtEditorCreateExternalTextAttributeTagged: anExistingTag registry: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ self gtEditorShouldBeAddedToRegistry
		ifTrue: [ self subclassResponsibility ].
]

{ #category : '*GToolkit-Editor' }
BlTextAttribute >> gtEditorShouldBeAddedToRegistry [
	^ false
]
