Extension { #name : 'BlRunRopedText' }

{ #category : '*GToolkit-Editor' }
BlRunRopedText >> asGtTextEditorText: anAttributesRegistry forTheme: aTheme during: aBlock [
	^ GtTextEditorExternalText
		fromString: ''
		during: [ :externalText | 
			rope
				allLeafsDo: [ :each | externalText insertString: each collection asString at: externalText size ].
				
			self attributeRunsDo: [ :start :stop :attributes |
				attributes do: [ :eachAttribute |
					eachAttribute
						gtEditorAsExternalTextAttribute: anAttributesRegistry
						forTheme: aTheme
						during: [ :externalAttribute |
							externalText
								attribute: externalAttribute
								from: start
								to: stop ] ] ].
	
			aBlock value: externalText ]
]
