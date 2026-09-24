"
I compare two ${class:GtTextEditorRecordersSnapshot}$ instances, typically one from a passing and one from a failing example execution, and show where the two editors diverged.

I exist as a separate object rather than as a view on the snapshot because a phlow view method receives only the view, so the receiver of a diff view has to hold both sides already.

My `Diff` view covers the commands and the messages, which are the complete lists. My `Adornment diff` covers the filtered ones, which are subsets of those; diffing all four would show the same divergence twice.
"
Class {
	#name : 'GtTextEditorRecordersComparison',
	#superclass : 'Object',
	#instVars : [
		'fromSnapshot',
		'toSnapshot'
	],
	#category : 'GToolkit-Editor-Debugging',
	#package : 'GToolkit-Editor',
	#tag : 'Debugging'
}

{ #category : 'instance creation' }
GtTextEditorRecordersComparison class >> from: aFromSnapshot to: aToSnapshot [
	<return: #GtTextEditorRecordersComparison>
	^ self new
		fromSnapshot: aFromSnapshot;
		toSnapshot: aToSnapshot;
		yourself
]

{ #category : 'accessing' }
GtTextEditorRecordersComparison >> countsTextFor: aSelector [
	"Answer how many entries aSelector holds on each side, so it is visible at a glance
	which of the lists moved before reading a diff at all."
	<return: #String>
	| aFromCount aToCount |
	aFromCount := (fromSnapshot perform: aSelector) size.
	aToCount := (toSnapshot perform: aSelector) size.
	^ aFromCount = aToCount
		ifTrue: [ '{1} (same)' format: { aFromCount } ]
		ifFalse: [ '{1} -> {2}' format: { aFromCount. aToCount } ]
]

{ #category : 'accessing' }
GtTextEditorRecordersComparison >> fromSnapshot [
	<return: #GtTextEditorRecordersSnapshot>
	^ fromSnapshot
]

{ #category : 'accessing' }
GtTextEditorRecordersComparison >> fromSnapshot: aSnapshot [
	fromSnapshot := aSnapshot
]

{ #category : 'views' }
GtTextEditorRecordersComparison >> gtAdornmentDiffFor: aView [
	<gtView>
	^ aView diff
		title: 'Adornment diff';
		from: [ fromSnapshot adornmentDiffString ];
		to: [ toSnapshot adornmentDiffString ];
		fromLabel: fromSnapshot label;
		toLabel: toSnapshot label
]

{ #category : 'views' }
GtTextEditorRecordersComparison >> gtDiffFor: aView [
	<gtView>
	^ aView diff
		title: 'Diff';
		from: [ fromSnapshot diffString ];
		to: [ toSnapshot diffString ];
		fromLabel: fromSnapshot label;
		toLabel: toSnapshot label
]

{ #category : 'views' }
GtTextEditorRecordersComparison >> gtInfoFor: aView [
	<gtView>
	^ aView details
		title: 'Info';
		row: 'Identical' value: [ self ] text: [ :aComparison | aComparison isIdentical printString ];
		row: 'From' value: [ fromSnapshot ] text: [ :aSnapshot | aSnapshot label ];
		row: 'To' value: [ toSnapshot ] text: [ :aSnapshot | aSnapshot label ];
		row: 'Commands'
			value: [ self ]
			text: [ :aComparison | aComparison countsTextFor: #commands ];
		row: 'Adornment Commands'
			value: [ self ]
			text: [ :aComparison | aComparison countsTextFor: #adornmentCommands ];
		row: 'Messages'
			value: [ self ]
			text: [ :aComparison | aComparison countsTextFor: #messages ];
		row: 'Adornment Messages'
			value: [ self ]
			text: [ :aComparison | aComparison countsTextFor: #adornmentMessages ]
]

{ #category : 'testing' }
GtTextEditorRecordersComparison >> isIdentical [
	"Answer whether the two snapshots recorded exactly the same commands and messages."
	<return: #Boolean>
	^ fromSnapshot diffString = toSnapshot diffString
]

{ #category : 'printing' }
GtTextEditorRecordersComparison >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: fromSnapshot label;
		nextPutAll: ' -> ';
		nextPutAll: toSnapshot label;
		nextPut: $)
]

{ #category : 'accessing' }
GtTextEditorRecordersComparison >> toSnapshot [
	<return: #GtTextEditorRecordersSnapshot>
	^ toSnapshot
]

{ #category : 'accessing' }
GtTextEditorRecordersComparison >> toSnapshot: aSnapshot [
	toSnapshot := aSnapshot
]
