Class {
	#name : 'GtTextEditorAttributesRegistry',
	#superclass : 'Object',
	#instVars : [
		'attributesToTags',
		'tagsToAttributes',
		'documentId'
	],
	#category : 'GToolkit-Editor-Text',
	#package : 'GToolkit-Editor',
	#tag : 'Text'
}

{ #category : 'as yet unclassified' }
GtTextEditorAttributesRegistry >> attributes [
	^ tagsToAttributes values
]

{ #category : 'accessing' }
GtTextEditorAttributesRegistry >> documentId [
	^ documentId
]

{ #category : 'accessing' }
GtTextEditorAttributesRegistry >> documentId: anObject [
	documentId := anObject
]

{ #category : 'as yet unclassified' }
GtTextEditorAttributesRegistry >> findAttribute: anAttributeTag ifFound: aFoundBlock [
	^ tagsToAttributes
			at: anAttributeTag
			ifPresent: aFoundBlock
]

{ #category : 'as yet unclassified' }
GtTextEditorAttributesRegistry >> findAttributeTag: anAttribute ifFound: aFoundBlock [
	^ attributesToTags
			at: anAttribute
			ifPresent: aFoundBlock
]

{ #category : 'as yet unclassified' }
GtTextEditorAttributesRegistry >> findAttributeTag: anAttribute ifFound: aFoundBlock ifNone: aNotFoundBlock [
	^ attributesToTags
			at: anAttribute
			ifPresent: aFoundBlock
			ifAbsent: aNotFoundBlock
]

{ #category : 'initialization' }
GtTextEditorAttributesRegistry >> initialize [
	super initialize.
	
	attributesToTags := OrderedDictionary new.
	tagsToAttributes := OrderedDictionary new.
]

{ #category : 'as yet unclassified' }
GtTextEditorAttributesRegistry >> postCopy [
	attributesToTags := attributesToTags copy.
	tagsToAttributes := tagsToAttributes copy
]

{ #category : 'as yet unclassified' }
GtTextEditorAttributesRegistry >> registerAttribute: aTextAttribute attributeTag: anAttributeTag [
	attributesToTags
		at: aTextAttribute
		ifPresent: [ :anExistingTag | 
			self
				error: ('Attribute ({1}) already registered with tag {2}.'
						format: {aTextAttribute.
								anExistingTag}) ]
		ifAbsentPut: [ anAttributeTag ].

	tagsToAttributes
		at: anAttributeTag
		ifPresent: [ :anExistingAttribute | 
			self
				error: ('Attribute tag ({1}) already registered for attribute {2}.'
						format: {anAttributeTag.
								anExistingAttribute}) ]
		ifAbsentPut: [ aTextAttribute ]
]

{ #category : 'as yet unclassified' }
GtTextEditorAttributesRegistry >> tagsAndAttributes [
	^ tagsToAttributes associations
]

{ #category : 'as yet unclassified' }
GtTextEditorAttributesRegistry >> unregisterAttributeByTag: anAttributeTag [
	tagsToAttributes
		at: anAttributeTag
		ifPresent: [ :anAttribute |
			attributesToTags removeKey: anAttribute.
			tagsToAttributes removeKey: anAttributeTag ]
]
