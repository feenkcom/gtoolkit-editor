"
I exemplify ${class:GtTextEditorRecordersSnapshot}$ and ${class:GtTextEditorRecordersComparison}$: taking a snapshot of what an editor recorded, and comparing two of them.

The rust editor records asynchronously, so a snapshot taken right after an edit can catch the recording halfway. My examples settle the editor first with ${method:GtTextEditorRecordersSnapshotExamples>>#waitUntilQuietOn:}$, or wait for a specific command to land with ${method:GtTextEditorRecordersSnapshotExamples>>#waitUntilCommandsCountExceeds:on:}$, rather than asserting straight after the triggering call.
"
Class {
	#name : 'GtTextEditorRecordersSnapshotExamples',
	#superclass : 'Object',
	#traits : 'TGtTextEditorElementExamples',
	#classTraits : 'TGtTextEditorElementExamples classTrait',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> adornmentEntriesAreSubsetOfCompleteEntries [
	"The rust side builds the adornment lists by filtering the complete ones, so every
	adornment entry has to appear among the complete entries."
	<gtExample>
	<return: #GtTextEditorRecordersSnapshot>
	| aSnapshot |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	aSnapshot := self snapshotOfRecordedEdits.
	aSnapshot adornmentCommands
		do: [ :eachEntry | self assert: (aSnapshot commands includes: eachEntry) ].
	aSnapshot adornmentMessages
		do: [ :eachEntry | self assert: (aSnapshot messages includes: eachEntry) ].
	^ aSnapshot
]

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> comparisonAcrossAnExtraEdit [
	<gtExample>
	<return: #GtTextEditorRecordersComparison>
	| anElement aHandle aBefore anAfter aComparison |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	anElement := self elementWithRecordedEdits.
	aHandle := anElement privateEditorHandle.
	aBefore := aHandle recordersSnapshotLabeled: 'before extra edit'.

	anElement moveCaretsUp.
	self waitUntilCommandsCountExceeds: aBefore commands size on: anElement.
	anAfter := aHandle recordersSnapshotLabeled: 'after extra edit'.

	aComparison := GtTextEditorRecordersComparison from: aBefore to: anAfter.
	self assert: aComparison isIdentical not.
	self assert: anAfter commands size > aBefore commands size.
	"The extra edit only appends, so everything recorded before is still recorded after."
	self
		assert: (aBefore commands allSatisfy: [ :eachEntry | anAfter commands includes: eachEntry ]).
	self
		assert: (aComparison countsTextFor: #commands)
		equals: ('{1} -> {2}' format: { aBefore commands size. anAfter commands size }).
	^ aComparison
]

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> comparisonDiffView [
	<gtExample>
	<return: #GtPhlowDiffView>
	| aComparison aView |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	aComparison := self comparisonAcrossAnExtraEdit.
	aView := aComparison gtDiffFor: GtPhlowView empty.
	self assert: aView class equals: GtPhlowDiffView.
	self assert: aView title equals: 'Diff'.
	self assert: aView from value equals: aComparison fromSnapshot diffString.
	self assert: aView to value equals: aComparison toSnapshot diffString.
	self assert: aView fromLabel equals: 'before extra edit'.
	self assert: aView toLabel equals: 'after extra edit'.
	^ aView
]

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> comparisonInfoView [
	<gtExample>
	<return: #GtPhlowDetailsView>
	| aComparison aView |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	aComparison := self comparisonAcrossAnExtraEdit.
	aView := aComparison gtInfoFor: GtPhlowView empty.
	self assert: aView class equals: GtPhlowDetailsView.
	self assert: aView title equals: 'Info'.
	self
		assert: (aView phlowDetailRows collect: [ :eachRow | eachRow name ]) asArray
		equals: #('Identical' 'From' 'To' 'Commands' 'Adornment Commands' 'Messages' 'Adornment Messages').
	^ aView
]

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> comparisonOfTwoQuietSnapshotsIsIdentical [
	"Two snapshots of the same editor, taken with no input in between, have to compare
	equal. Otherwise the comparison would be flaky itself and useless for telling a
	passing run from a failing one."

	<gtExample>
	<return: #GtTextEditorRecordersComparison>
	| aHandle aComparison |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	aHandle := self elementWithRecordedEdits privateEditorHandle.
	aComparison := GtTextEditorRecordersComparison
			from: (aHandle recordersSnapshotLabeled: 'first')
			to: (aHandle recordersSnapshotLabeled: 'second').
	self assert: aComparison isIdentical.
	self
		assert: (aComparison countsTextFor: #commands)
		equals: ('{1} (same)' format: {aComparison fromSnapshot commands size}).
	^ aComparison
]

{ #category : 'private' }
GtTextEditorRecordersSnapshotExamples >> countsOn: anElement [
	"Answer how many commands and messages anElement's editor has recorded so far."
	<return: #Array>
	| aSnapshot |
	aSnapshot := anElement privateEditorHandle recordersSnapshotLabeled: 'probe'.
	^ Array with: aSnapshot commands size with: aSnapshot messages size
]

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> elementWithRecordedEdits [
	"An editor element that recorded a text insertion and was then left to settle."
	<gtExample>
	<return: #GtTextEditorElement>
	| anElement aHandle |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	anElement := self elementWithoutRecorders.
	aHandle := anElement privateEditorHandle.
	aHandle enableInMemoryCommandsRecorder.
	aHandle insertStringAtCursor: 'XYZ'.
	self waitUntilQuietOn: anElement.
	^ anElement
]

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> elementWithoutRecorders [
	<gtExample>
	<return: #GtTextEditorElement>
	| anElement |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	anElement := GtTextEditorElement new.
	anElement exact: 200 @ 200.
	anElement text: 'abcd' asRopedText.
	^ anElement
]

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> emptySnapshotWithoutRecorders [
	"A handle that never enabled the in-memory recorders answers an empty snapshot
	rather than failing."

	<gtExample>
	<return: #GtTextEditorRecordersSnapshot>
	| aSnapshot |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	aSnapshot := self elementWithoutRecorders privateEditorHandle
			recordersSnapshotLabeled: 'not recording'.
	self assert: aSnapshot isEmpty.
	self assert: aSnapshot commands isEmpty.
	self assert: aSnapshot adornmentCommands isEmpty.
	self assert: aSnapshot messages isEmpty.
	self assert: aSnapshot adornmentMessages isEmpty.
	^ aSnapshot
]

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> snapshotDiffStringHasBothSections [
	"Each recorded entry has to take exactly one line of the diff text, so that a diff
	aligns entry against entry. Message entries are multi line as the rust side prints
	them, so the snapshot folds them onto one line."

	<gtExample>
	<return: #String>
	| aSnapshot aString theLines |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	aSnapshot := self snapshotOfRecordedEdits.
	aString := aSnapshot diffString.
	theLines := aString lines.
	self
		assert: theLines first
		equals: ('--- Commands ({1}) ---' format: {aSnapshot commands size}).
	self
		assert: (theLines includes: ('--- Messages ({1}) ---' format: {aSnapshot messages size})).
	aSnapshot commands
		do: [ :eachEntry | self assert: (theLines includes: (aSnapshot oneLineOf: eachEntry)) ].
	aSnapshot messages
		do: [ :eachEntry | self assert: (theLines includes: (aSnapshot oneLineOf: eachEntry)) ].	"Two section headers, one blank separator, and one line per entry."
	self
		assert: theLines size
		equals: 3 + aSnapshot commands size + aSnapshot messages size.
	^ aString
]

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> snapshotInfoView [
	<gtExample>
	<return: #GtPhlowDetailsView>
	| aSnapshot aView |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	aSnapshot := self snapshotOfRecordedEdits.
	aView := aSnapshot gtInfoFor: GtPhlowView empty.
	self assert: aView class equals: GtPhlowDetailsView.
	self assert: aView title equals: 'Info'.
	self
		assert: (aView phlowDetailRows collect: [ :eachRow | eachRow name ]) asArray
		equals: #('Label' 'Taken at' 'Commands' 'Adornment Commands' 'Messages' 'Adornment Messages').
	^ aView
]

{ #category : 'examples' }
GtTextEditorRecordersSnapshotExamples >> snapshotOfRecordedEdits [
	<gtExample>
	<return: #GtTextEditorRecordersSnapshot>
	| aSnapshot |
	self ifLibEditorExamplesCannotBeExecutedDo: [ ^ nil ].
	aSnapshot := self elementWithRecordedEdits privateEditorHandle
			recordersSnapshotLabeled: 'recorded edits'.
	self assert: aSnapshot label equals: 'recorded edits'.
	self assert: aSnapshot isEmpty not.
	self assert: aSnapshot commands isNotEmpty.
	self assert: aSnapshot messages isNotEmpty.
	self assert: (aSnapshot commands allSatisfy: [ :eachEntry | eachEntry isString ]).
	^ aSnapshot
]

{ #category : 'private' }
GtTextEditorRecordersSnapshotExamples >> waitUntilCommandsCountExceeds: aCount on: anElement [
	"Drain the editor until a further command has been recorded. Waiting for the count to
	grow is more reliable than waiting for the counts to settle, because a settled count
	cannot tell a command that has not landed yet from one that never will."
	| aDeadline |
	aDeadline := DateAndTime now + 2 seconds.
	[ anElement pollEditorMessages.
	((self countsOn: anElement) first > aCount or: [ DateAndTime now > aDeadline ]) ]
		whileFalse: [ (Delay forMilliseconds: 20) wait ]
]

{ #category : 'private' }
GtTextEditorRecordersSnapshotExamples >> waitUntilQuietOn: anElement [
	"Drain the editor until its recorded counts stop changing, so that a snapshot taken
	afterwards is not racing the recording. Commands and embedder messages arrive through
	a polled FFI queue, so both counts have to hold still, not just the commands."
	| aDeadline aPreviousCounts aCurrentCounts |
	aDeadline := DateAndTime now + 2 seconds.
	aPreviousCounts := nil.
	[ anElement pollEditorMessages.
	aCurrentCounts := self countsOn: anElement.
	((aCurrentCounts first > 0 and: [ aCurrentCounts = aPreviousCounts ])
		or: [ DateAndTime now > aDeadline ]) ]
		whileFalse: [
			aPreviousCounts := aCurrentCounts.
			(Delay forMilliseconds: 20) wait ]
]
