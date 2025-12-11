Extension { #name : 'BlRunRopedText' }

{ #category : '*GToolkit-Editor' }
BlRunRopedText >> asGtTextEditorTextDuring: aBlock [
	^ GtTextEditorExternalText
		fromString: ''
		during: [ :externalText | 
			rope
				allLeafsDo: [ :each | externalText insertString: each collection asString at: externalText size ].
				
			self attributeRunsDo: [ :start :stop :attributes |
				attributes do: [ :eachAttribute |
					externalText
						attribute: eachAttribute
						from: start
						to: stop ] ].
	
			aBlock value: externalText ]
]

{ #category : '*GToolkit-Editor' }
BlRunRopedText >> asGtTextEditorTextForTheme: aTheme during: aBlock [
	^ GtTextEditorExternalText
		fromString: ''
		during: [ :externalText | 
			rope
				allLeafsDo: [ :each | externalText insertString: each collection asString at: externalText size ].
				
			self attributeRunsDo: [ :start :stop :attributes |
				attributes do: [ :eachAttribute |
					eachAttribute
						asGtExternalTextAttributeForTheme: aTheme
						during: [ :externalAttribute |
							externalText
								attribute: externalAttribute
								from: start
								to: stop ] ] ].
	
			aBlock value: externalText ]
]
