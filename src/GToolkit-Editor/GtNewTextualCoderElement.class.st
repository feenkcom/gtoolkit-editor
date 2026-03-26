Class {
	#name : 'GtNewTextualCoderElement',
	#superclass : 'BlElement',
	#traits : 'TBlAssertUIProcess + TGtWithTextualCoderViewModel + TBrLayoutResizable',
	#classTraits : 'TBlAssertUIProcess classTrait + TGtWithTextualCoderViewModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'evaluationHighlighter',
		'evaluationPrinter',
		'shortcuts',
		'cursorsUpdater',
		'textUpdater',
		'addOnsElementFuture',
		'editorElement'
	],
	#category : 'GToolkit-Editor-UI',
	#package : 'GToolkit-Editor',
	#tag : 'UI'
}

{ #category : 'private' }
GtNewTextualCoderElement >> addErrorAttribute: errorAttribute at: anInteger [
	| text position |
	text := self editor text.
	position := anInteger - 1 max: 0.
	text size < position ifTrue: [ ^ self ].
	text clearAttributesOfClass: GtSourceCoderErrorAttribute.
	text
		attribute: errorAttribute
		from: position
		to: position.
	self scrollToPosition: (text asString lineNumberCorrespondingToIndex: position)
]

{ #category : 'hooks - children' }
GtNewTextualCoderElement >> attachSpace [
	super attachSpace.
	
	GtTextualCoderEditorElementAttachedSpaceSignal new 
		element: self;
		emit
]

{ #category : 'api - textual coder view model' }
GtNewTextualCoderElement >> coderViewModel: aTextualCoderViewModel [
	self textualCoderViewModel: aTextualCoderViewModel
]

{ #category : 'private - updating' }
GtNewTextualCoderElement >> computeTextForUpdateForTextChangedEvent: aGtTextualCoderViewModelTextChanged [ 
	"In case the editor has a text edit command we determine 
	the updated text by editing the text currently in the
	editor. If no edit command is present in the event,
	we take the text from the event. We use the edit command
	to avoid setting the text from the event which is not 
	styled, and can cause flickerings."
	
	^ aGtTextualCoderViewModelTextChanged hasTextEditCommand
		ifTrue: [ 
			| editCommand|
			editCommand :=  aGtTextualCoderViewModelTextChanged textEditCommand.
			self editedTextBasedOnEditCommand: editCommand.  ]
		ifFalse: [ 
			aGtTextualCoderViewModelTextChanged text copy ]
]

{ #category : 'instance creation' }
GtNewTextualCoderElement >> createContextMenu [
	"wait for the addons to be computed"
	<return: #BrMenuItems>

	| aMenu aMenuItemsPromise |
	aMenu := BrMenuItems new.
	aMenu beGroupedElementType.

	aMenuItemsPromise := self textualCoderViewModel addOns
			asyncThen: [ :theAddOns | 
				| theItems theContextMenuAstAddons theMenuItems |
				"extra context menu items that depend on ast and view model state such as selection"
				theContextMenuAstAddons := self textualCoderViewModel
						computeContextMenuAstAddOns.
				theItems := theAddOns contextMenuActions, theContextMenuAstAddons contextMenuActions.
				theItems := theItems reject: [ :e | e title isNil ].
				
				theMenuItems := theItems 
					collect: [ :eachAction | eachAction asBrMenuItemForCoderElement: self ]
					thenReject: #isNil.
				
				self enqueueTask: (BlTaskAction new 
					action: [ 
						aMenu items: theMenuItems ]) ].

	self enqueueTask: (BlPromiseTask new promise: aMenuItemsPromise).

	^ aMenu 
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> deleter [
	"This method should be deprecated and removed, instead add higher-level api methods"
	self flag: #TODO.
	
	^ editorElement deleter
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> deselecter [
	"This method should be deprecated and removed, instead add higher-level api methods"
	self flag: #TODO.
	
	^ editorElement deselecter
]

{ #category : 'hooks - children' }
GtNewTextualCoderElement >> detachSpace [
	super detachSpace.
	
	GtTextualCoderEditorElementDetachedSpaceSignal new 
		element: self;
		emit
]

{ #category : 'private - updating' }
GtNewTextualCoderElement >> editedTextBasedOnEditCommand: aTextEditCommand [
	| modifiedText|
	"self haltOnce."

	modifiedText := self text copy.
	aTextEditCommand applyTextChangeOn: modifiedText. 
	^ modifiedText  
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> editor [
	"This method should be deprecated and removed, instead add higher-level api methods"
	self flag: #TODO.
	
	^ editorElement editor
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> editorElement [
	^ editorElement
]

{ #category : 'focus requesting' }
GtNewTextualCoderElement >> focusTarget [
	^ editorElement
]

{ #category : 'private' }
GtNewTextualCoderElement >> hideHighlighters [
	self text clearAttributes: [ :eachAttribute | 
		eachAttribute isKindOf: GtSourceCoderErrorAttribute ].
	evaluationHighlighter hideResultSynchronously.
	evaluationPrinter hideResultSynchronously.
]

{ #category : 'initialization' }
GtNewTextualCoderElement >> initialize [
	super initialize.
	
	editorElement := GtTextEditorElement new.
	editorElement privateEditorHandle enableInMemoryCommandsRecorder.
	editorElement
		defaultFontName: 'Source Code Pro';
		defaultFontSize: 14;
		defaultForeground: Color black;
		id: GtSourceCoderEditorInnerId;
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude menu: [ self createContextMenu ]);
		padding: BlInsets empty.

	self addChild: editorElement.
	
	self
		layout: BlLinearLayout vertical;
		addAptitude: (BrLayoutResizerAptitude new inherit: editorElement);
		hMatchParent;
		vFitContentLimited.

	self id: GtSourceCoderEditorId.

	shortcuts := #().

	evaluationHighlighter := GtSourceCoderEvaluationHighlighter new editorElement: self.
	evaluationPrinter := GtSourceCoderEvaluationPrinter new editorElement: self.
	
	cursorsUpdater := BrElementUpdater new
		element: self;
		action: (MessageSend receiver: self selector: #privateUpdateCursors:announcement:).

	textUpdater := BrElementUpdater new
		element: self;
		action: (MessageSend receiver: self selector: #privateUpdateText:announcement:).

	addOnsElementFuture := (BrAsyncElementFuture on: self)
		executionConfiguration: (GtSingleCoderViewModel methodAddOnsExecutionConfiguration);
		whenSuccess: [ :anEditorElement :theAddOns |
			self textualCoderViewModel onAddOnsChanged: theAddOns ];
		whenError: [ :anEditorElement :anError | 
			self onAddOnsError: anError ].

	self initializeListeners.

	self withAsyncPromiseDo: [ :anElementPromise |
			anElementPromise
				whenSuccess: [ :anEditorElement :anEditorState | anEditorElement privateUpdateEditorState: anEditorState ];
				whenError: [ :anEditorElement :anEditorState |  ];
				whenPending: [ :anEditorElement | ] ]
]

{ #category : 'initialization' }
GtNewTextualCoderElement >> initializeListeners [
	self 
		when: BlFocusInEvent 
		do: [ :anEvent | self onFocusInEvent: anEvent ].
		
	self 
		when: BlFocusOutEvent 
		do: [ :anEvent | self onFocusOutEvent: anEvent ].
	
	editorElement
		when: BrTextEditorHistoryChangedEvent
		do: [ :anEvent | self onTextEditorHistoryChanged: anEvent ].

	editorElement
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | self onTextModifiedDueToEvent: anEvent ].

	editorElement
		when: BrTextEditorCursorChangedEvent
		do: [ :anEvent | self onTextEditorCursorChanged: anEvent ].

	editorElement
		when: BrTextEditorSelectionChangedEvent
		do: [ :anEvent | self onTextEditorSelectionChanged: anEvent ].

	editorElement
		when: BrTextEditorTextStyledEvent
		do: [ :anEvent | self onTextStyled: anEvent ]
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> inserter [
	"This method should be deprecated and removed, instead add higher-level api methods"
	self flag: #TODO.
	
	^ editorElement inserter
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> navigator [
	"This method should be deprecated and removed, instead add higher-level api methods"
	self flag: #TODO.
	
	^ editorElement navigator
]

{ #category : 'initialization' }
GtNewTextualCoderElement >> onAddOnsError: anError [
	anError emit.
	NonInteractiveTranscript stderr
		show: '[GtTextualCoderEditorElement>>#onAddOnsError:] ';
		show: anError;
		newLine
]

{ #category : 'hooks - children' }
GtNewTextualCoderElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	
	GtTextualCoderEditorElementAddedToSceneGraphSignal new 
		element: self;
		emit
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onCodeEvaluated: anEvaluationAnnouncement [
	(anEvaluationAnnouncement requesterObject
		isCoderViewModel: self textualCoderViewModel) ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ 
			evaluationHighlighter displayResult: anEvaluationAnnouncement evaluationResult.
			evaluationPrinter hideResult ]
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onCoderParseError: aGtCoderParseError [
	"A parse error can be notifying from a non-UI thread"

	(aGtCoderParseError requesterObject
		isUndefinedOrCoderViewModel: self textualCoderViewModel) ifFalse: [ ^ self ].
	self
		enqueueTask: [ aGtCoderParseError isUndeclaredError
				ifTrue: [ self reportUndeclaredError: aGtCoderParseError ]
				ifFalse: [ self
						reportParseError: aGtCoderParseError errorMessage
						at: aGtCoderParseError location ] ] asBlTask
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onCoderViewModelFocused: aBoolean [
	aBoolean
		ifTrue: [ self requestFocus ]
		ifFalse: [ self loseFocus ]
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onFocusChangedAnnouncement: anAnnouncement [
	anAnnouncement source == self ifTrue: [ ^ self ].

	anAnnouncement source == self textualCoderViewModel ifFalse: [ ^ self ].

	self
		enqueueTask: (BlTaskAction new
				action: [ self onCoderViewModelFocused: anAnnouncement focused ])
]

{ #category : 'initialization' }
GtNewTextualCoderElement >> onFocusInEvent: anEvent [
	self hasTextualCoderViewModel ifFalse: [ ^ self ].

	self textualCoderViewModel focused: true from: self
]

{ #category : 'initialization' }
GtNewTextualCoderElement >> onFocusOutEvent: anEvent [
	anEvent isDueToRemoval ifTrue: [ ^ self ].
	self hasTextualCoderViewModel ifFalse: [ ^ self ].

	self textualCoderViewModel focused: false from: self
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onObjectSpawnRequest: anAnnouncement [
	(anAnnouncement requesterObject isCoderViewModel: self textualCoderViewModel) 
		ifFalse: [ ^ self ].

	self enqueueTask: (BlTaskAction new action: [
		self phlow
			spawnObject: anAnnouncement object
			withDestination: anAnnouncement spawnDestination ])
]

{ #category : 'api - textual coder view model' }
GtNewTextualCoderElement >> onPostTextualCoderViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToTextualCoderViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	
	self textualCoderViewModel requestUpdateAddOns
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onPrintRequest: anEvaluationAnnouncement [
	(anEvaluationAnnouncement requesterObject isCoderViewModel: self textualCoderViewModel) 
		ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [
		evaluationHighlighter hideResult.
		evaluationPrinter displayResult: anEvaluationAnnouncement evaluationResult ].
]

{ #category : 'hooks - children' }
GtNewTextualCoderElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	
	GtTextualCoderEditorElementRemovedFromSceneGraphSignal new 
		element: self;
		emit
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onScrollToCharacterPositionAnnouncement: anAnnouncement [
	self assertUIProcess.
	BrEditorSearchTextScroller new
		editorElement: self;
		lineIndex: anAnnouncement lineIndex;
		characterStartPosition: anAnnouncement characterPosition;
		characterStopPosition: anAnnouncement characterPosition;
		scroll
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onSearchTextGetTextAndVisibleTextAnnouncement: anAnnouncement [
	self assertUIProcess.
	anAnnouncement consumed ifTrue: [ ^ self ].
	anAnnouncement consumed: true.
	
	anAnnouncement text: self text.
	anAnnouncement visibleText: self visibleText
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onSearchTextUpdateTextAnnouncement: anAnnouncement [
	| aResult |
	self assertUIProcess.
	anAnnouncement consumed ifTrue: [ ^ self ].
	anAnnouncement consumed: true.

	aResult := BrEditorSearchTextUpdater new
		editorModel: self editor;
		styledText: anAnnouncement styledText;
		update.
		
	anAnnouncement isUpdated: aResult
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onStyleTextRequest: anEvent [
	"onStyleTextRequest: may be sent from a non-UI thread"

	self enqueueTask: (BlTaskAction new action: [ self styleTextAndAfterDo: anEvent afterAction ])
]

{ #category : 'initialization' }
GtNewTextualCoderElement >> onTextEditorCursorChanged: anEvent [
	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	
	self textualCoderViewModel cursors: anEvent cursors from: self
]

{ #category : 'initialization' }
GtNewTextualCoderElement >> onTextEditorHistoryChanged: anEvent [
	self hasTextualCoderViewModel ifFalse: [ ^ self ].

	self textualCoderViewModel history: self editor history copy
]

{ #category : 'initialization' }
GtNewTextualCoderElement >> onTextEditorSelectionChanged: anEvent [
	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	
	self textualCoderViewModel selection: anEvent selection from: self
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onTextModified [
	"Is sent when the text changes in the editor. Here we should synchronise the UI and the model."
	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	
	self textualCoderViewModel
		sourceText: self text
		from: self
		synchronously: true
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onTextModifiedDueToEvent: aTextModifiedEvent [
	"Is sent when the text changes in the editor. Here we should synchronise the UI and the model. We also receive the event, which can contain the type of change."
	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	
	self textualCoderViewModel
		sourceText: self text
		from: self
		synchronously: true
		dueToEvent: aTextModifiedEvent
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onTextStyled: anEvent [
	"An underlying editor styled the text"
	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	
	self textualCoderViewModel styledText: anEvent styledText
]

{ #category : 'api - textual coder view model' }
GtNewTextualCoderElement >> onTextualCoderViewModelChanged [
	"Is sent when a new textualCoder view model is assigned to the element.
	Note: #onTextualCoderViewModelChanged is sent before #subscribeToTextualCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostTextualCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	| coderModel |
	coderModel := self textualCoderViewModel coderModel.
	(coderModel isForMethod and: [ coderModel compiledMethod isNotNil ]) ifTrue: 
		[ false"coderModel compiledMethod isBigMethod" ifTrue:
			[ editorElement beReadOnlyWithSelection ] ].
			
	editorElement model: self textualCoderViewModel.
	
	self onCoderViewModelFocused: self textualCoderViewModel focused.

	"Setting text may change cursor and selection because text editor makes sure
	that they have valid values. That is why we create a snaphot of the editor's state
	which we will restore once new text is set"

	"Related to: https://github.com/feenkcom/gtoolkit/issues/3727"
	self privateUpdateEditorState: self textualCoderViewModel asEditorState.

	shortcuts := self textualCoderViewModel shortcuts copy.
	self editor addEditorShortcuts: shortcuts.
	
	editorElement completionStrategy: self textualCoderViewModel completionStrategy.
	
	self textualCoderViewModel compositeStyler ifNotNil: [ :aStyler | 
		self styler: aStyler ]
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onToolSpawnRequest: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [
		anAnnouncement requesterObject = self textualCoderViewModel ifTrue: [
			self phlow
				spawnTool: anAnnouncement tool
				withDestination: anAnnouncement spawnDestination ] ])
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onViewModelCursorsChanged: aCursorsChangedAnnouncement [
	"Is sent when the cursors changes in the View Model.
	May be sent from a non-UI thread"
	
	"if the source of the announcement is myself, do nothing to break the change cycle"
	aCursorsChangedAnnouncement source = self
		ifTrue: [ ^ self ].

	"do nothing if it comes from a different view model"
	aCursorsChangedAnnouncement textualCoderViewModel == self textualCoderViewModel
		ifFalse: [ ^ self ].

	"since it may be sent from a non-UI process make sure to wrap in the action"
	cursorsUpdater requestUpdate: aCursorsChangedAnnouncement
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onViewModelReadyToStyle [
	self enqueueTask: (BlTaskAction new action: [ self styleText ])
]

{ #category : 'registration' }
GtNewTextualCoderElement >> onViewModelRecomputeAddOns: aRecomputeAddOnRequest [
	aRecomputeAddOnRequest coderViewModel == self textualCoderViewModel
		ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ addOnsElementFuture future: self textualCoderViewModel addOnsFuture ]
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onViewModelSelectionChanged: aSelectionChangedAnnouncement [
	"Is sent when the selection changes in the View Model.
	May be sent from a non-UI thread"

	"if the source of the announcement is myself, do nothing to break the change cycle"

	aSelectionChangedAnnouncement source = self ifTrue: [ ^ self ].

	aSelectionChangedAnnouncement source == self textualCoderViewModel
		ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self deselecter all deselect.
			self selecter
				in: [ :aSelecter | 
					aSelectionChangedAnnouncement shouldUpdateCursor
						ifFalse: [ aSelecter withoutCursorUpdate ] ];
				all: aSelectionChangedAnnouncement selection;
				select ]
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onViewModelShortcutsChanged [
	"Is sent when the shortcuts change in the View Model.
	May be sent from a non-UI thread"

	"since it may be sent from a non-UI process make sure to wrap in the action"
	self enqueueTask: (BlTaskAction new action: [
		self editor removeEditorShortcuts: shortcuts.
		shortcuts := self textualCoderViewModel shortcuts copy.
		self editor addEditorShortcuts: shortcuts ])
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onViewModelStyledTextChanged: anAnnouncement [
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onViewModelStylersChanged [
	self enqueueTask: (BlTaskAction new
		action: [ self styler: self textualCoderViewModel compositeStyler ])
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onViewModelTextAttributesAdded: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [
		anAnnouncement text characters = self text characters
			ifTrue: [
				anAnnouncement coderTextAttributes
					applyOnEditorText: self text
					from: anAnnouncement startPosition
					to: anAnnouncement stopPosition ] ])
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onViewModelTextAttributesRemoved: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [
		anAnnouncement coderTextAttributes removeFromEditorText: self text ])
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onViewModelTextChanged: aGtTextualCoderViewModelTextChanged [
	"Text changed in a view model and should be synchronised on the UI side.
	There can be multiple sources of the text change:
	 - an editor element itself
	 - other sources that changed text through coder model api.
	 
	 When the source is a text editor element (`self`) we don't reset the text in the editor.
	 If an announcement comes from a different view model, we skip it."


	"Do nothing if it comes from a different view model"
	aGtTextualCoderViewModelTextChanged textualCoderViewModel == self textualCoderViewModel
		ifFalse: [ ^ self ].
		
	BlTaskAction 
		enqueueElement: self 
		action: [ self processViewModelTextChanged: aGtTextualCoderViewModelTextChanged ].
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> onViewModelTextEditCommandRequest: aGtTextualCoderViewModelTextEditCommandRequest [
	"This is sent by the view model on requests to change the text 
	in the editor by executing a command."

	BlTaskAction
		enqueueElement: self
		action: [
			aGtTextualCoderViewModelTextEditCommandRequest textEditCommand
				applyOn: self editor ]
]

{ #category : 'private - updating' }
GtNewTextualCoderElement >> privateUpdateCursors: anEditorElement announcement: aCursorsChangedAnnouncement [

	"do nothing if it comes from a different view model"
	aCursorsChangedAnnouncement source == self textualCoderViewModel
		ifFalse: [ ^ self ].

	GtTextualCoderEditorElementUpdateCursorsSignal new 
		element: self;
		emit.

	self navigator
		withoutResettingDesiredCoordinate;
		removeAll;
		addAll: aCursorsChangedAnnouncement cursors;
		apply
]

{ #category : 'private - updating' }
GtNewTextualCoderElement >> privateUpdateEditorState: anEditorState [
	GtTextualCoderEditorElementUpdateStateSignal new 
		element: self;
		emit.

	anEditorState textDo: [ :aText |
		editorElement text: aText
	].
		
	"self editor restoreState: anEditorState"
]

{ #category : 'private - updating' }
GtNewTextualCoderElement >> privateUpdateText: anEditorElement announcement: aGtTextualCoderViewModelTextChanged [
	| textForUpdate |
	"Executed in a UI thread as a result of text being changed in the view model"

	"do nothing if it comes from a different view model"
	aGtTextualCoderViewModelTextChanged textualCoderViewModel == self textualCoderViewModel
		ifFalse: [ ^ self ].

	GtTextualCoderEditorElementUpdateTextSignal new 
		element: self;
		emit.

	"Determine the text that we should use to update the editor."
	textForUpdate := self computeTextForUpdateForTextChangedEvent: aGtTextualCoderViewModelTextChanged.
	
	self text: textForUpdate.
	self hideHighlighters.
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> processViewModelTextChanged: aGtTextualCoderViewModelTextChanged [ 
	aGtTextualCoderViewModelTextChanged source == self
		ifTrue: [ ^ self hideHighlighters ].
	
	aGtTextualCoderViewModelTextChanged isSynchronous
		ifTrue: [ self privateUpdateText: self announcement: aGtTextualCoderViewModelTextChanged ] 
		ifFalse: [ textUpdater requestUpdate: aGtTextualCoderViewModelTextChanged ]
]

{ #category : 'registration' }
GtNewTextualCoderElement >> registerCoderModelAnnouncementsFor: aCoderModel [
	aCoderModel announcer weak
		when: GtCoderStyleTextRequest send: #onStyleTextRequest: to: self;
		when: GtCoderParseError send: #onCoderParseError: to: self;
		when: GtCoderObjectSpawnRequest
			send: #onObjectSpawnRequest:
			to: self;
		when: GtCoderToolSpawnRequest send: #onToolSpawnRequest: to: self;
		when: GtCoderEvaluationAnnouncement
			send: #onCodeEvaluated:
			to: self;
		when: GtCoderPrintAnnouncement send: #onPrintRequest: to: self
]

{ #category : 'registration' }
GtNewTextualCoderElement >> registerCoderViewModelAnnouncementsFor: aGtSourceCoderUIModel [
	aGtSourceCoderUIModel weak
		when: GtCoderViewModelRecomputeAddOnRequest
			send: #onViewModelRecomputeAddOns:
			to: self;
		when: GtTextualCoderViewModelFocusChanged
			send: #onFocusChangedAnnouncement:
			to: self;
		when: GtTextualCoderViewModelTextChanged
			send: #onViewModelTextChanged:
			to: self;
		when: GtTextualCoderViewModelTextEditCommandRequestAnnouncement
			send: #onViewModelTextEditCommandRequest:
			to: self;
		when: GtTextualCoderViewModelCursorsChanged
			send: #onViewModelCursorsChanged:
			to: self;
		when: GtTextualCoderViewModelSelectionChanged
			send: #onViewModelSelectionChanged:
			to: self;
		when: GtTextualCoderViewModelStylersChanged
			send: #onViewModelStylersChanged
			to: self;
		when: GtTextualCoderViewModelShortcutsChanged
			send: #onViewModelShortcutsChanged
			to: self;
		when: GtTextualCoderViewModelReadyToRestyle
			send: #onViewModelReadyToStyle
			to: self;
		when: GtTextualCoderViewModelTextAttributesAdded
			send: #onViewModelTextAttributesAdded:
			to: self;
		when: GtTextualCoderViewModelTextAttributesRemoved
			send: #onViewModelTextAttributesRemoved:
			to: self;
		when: GtTextualCoderViewModelStyledTextChanged
			send: #onViewModelStyledTextChanged:
			to: self;
		when: GtTextualCoderViewModelScrollToCharacterPositionAnnouncement
			send: #onScrollToCharacterPositionAnnouncement:
			to: self;
		when: GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement
			send: #onSearchTextGetTextAndVisibleTextAnnouncement:
			to: self;
		when: GtTextualCoderViewModelSearchTextUpdateTextAnnouncement
			send: #onSearchTextUpdateTextAnnouncement:
			to: self
]

{ #category : 'private' }
GtNewTextualCoderElement >> reportParseError: aString at: anInteger [
	| error |
	error := (aString endsWith: '->')
			ifTrue: [ aString allButLast: 2 ]
			ifFalse: [ aString ].
	self addErrorAttribute: (GtSourceCoderErrorAttribute for: error) at: anInteger
]

{ #category : 'private - event handling' }
GtNewTextualCoderElement >> reportUndeclaredError: aGtCoderParseError [
	| rbNode interval gtNode ast errorAttribute |
	rbNode := aGtCoderParseError node.
	interval := rbNode sourceInterval.
	ast := GtPharoParser
			parse: rbNode methodNode source
			startingAt: (rbNode methodNode isDoIt
					ifTrue: [ GtPharoParser startingStateForDoItMethod ]
					ifFalse: [ GtPharoParser startingStateForMethod ]).
	gtNode := ast nodeForInterval: interval.
	errorAttribute := GtUndeclaredVariableAdvice new
			errorAttribute: gtNode
			coderModel: aGtCoderParseError coder.
	self addErrorAttribute: errorAttribute at: aGtCoderParseError location
]

{ #category : 'private' }
GtNewTextualCoderElement >> scrollToPosition: anObject [
	editorElement scrollToPosition: anObject
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> selecter [
	"This method should be deprecated and removed, instead add higher-level api methods"
	self flag: #TODO.
	
	^ editorElement selecter
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> selection [
	"This method should be deprecated and removed, instead add higher-level api methods"
	self flag: #TODO.
	
	^ editorElement selection
]

{ #category : 'private' }
GtNewTextualCoderElement >> showScrollbars [
	self
		addAptitude: (BrGlamorousWithVerticalScrollbarAptitude new scrollableName: editorElement id)
]

{ #category : 'private' }
GtNewTextualCoderElement >> styleText [
	self editor requestManualStyling
]

{ #category : 'private' }
GtNewTextualCoderElement >> styleTextAndAfterDo: aBlock [
	self editor styleTextAndAfterDo: aBlock
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> styler: anObject [
	editorElement styler: anObject
]

{ #category : 'api - textual coder view model' }
GtNewTextualCoderElement >> subscribeToTextualCoderViewModel [
	"Is sent after a new textualCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromTextualCoderViewModel if elements subscribe to them"

	self registerCoderModelAnnouncementsFor: self textualCoderViewModel coderModel.
	self registerCoderViewModelAnnouncementsFor: self textualCoderViewModel.
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> text [
	^ editorElement unstyledText asRopedText
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> text: aBlText [
	(self text equalsIgnoringAttributes: aBlText)
		ifTrue: [ "self editor history disableDuring: [ editorElement text: aBlText" ].
	editorElement text: aBlText
]

{ #category : 'api - textual coder view model' }
GtNewTextualCoderElement >> unsubscribeFromTextualCoderViewModel [
	"Is sent before a new textualCoder view model is assigned to the element.
	Elements that subscribe to textualCoder view model in domain model are required to implement this methods."
	
	self textualCoderViewModel unsubscribe: self.
	self textualCoderViewModel coderModel unsubscribe: self.
	
	self editor removeEditorShortcuts: shortcuts
]

{ #category : 'TODO' }
GtNewTextualCoderElement >> visibleText [
	^ editorElement visibleText
]
