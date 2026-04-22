Extension { #name : 'GtPharoRenameSelectorModelExamples' }

{ #category : '*GToolkit-Editor' }
GtPharoRenameSelectorModelExamples >> createRustEditorWithMethod: aMethod [
	| anEditor aDocumentId aController |
	aDocumentId := nil.
	anEditor := GtTextEditorElement new
			defaultFontName: 'Source Code Pro';
			defaultFontSize: 14;
			defaultForeground: Color black;
			in: [ :theEditor | theEditor privateEditorHandle enableInMemoryCommandsRecorder ];
			when: BrTextEditorModifiedEvent
				do: [ :anEvent | aDocumentId := anEvent documentId ];
			matchParent;
			yourself.
	
	anEditor text: aMethod sourceCode.

	aController := GtPharoRenameSelectorCoderController new
			originalNode: aMethod ast;
			editorElement: anEditor;
			sourceCoderViewModel: (GtPharoMethodCoder forMethod: aMethod) asCoderViewModel;
			install.

	anEditor userData at: #selectorController put: aController.

	^ anEditor
]

{ #category : '*GToolkit-Editor' }
GtPharoRenameSelectorModelExamples >> rustEditorWithThreeKeywordsMethod [
	<gtExample>
	| aMethod anEditor |
	aMethod := self threeKeywordsMethod.
	anEditor := self createRustEditorWithMethod: aMethod.
	^ anEditor
]
