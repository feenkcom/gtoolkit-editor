"
I hold what the in-memory recorders of a ${class:GtTextEditorHandle}$ captured up to the moment I was taken, as plain strings.

I am built by ${method:GtTextEditorHandle>>#recordersSnapshotLabeled:}$. Because I hold strings rather than the Rust-owned recorders, I outlive the editor that produced me, which is what makes it possible to compare a passing and a failing example execution with ${class:GtTextEditorRecordersComparison}$.

My `adornmentCommands` are a subset of my `commands`, and my `adornmentMessages` a subset of my `messages`; the Rust side filters them by command and message variant.
"
Class {
	#name : 'GtTextEditorRecordersSnapshot',
	#superclass : 'Object',
	#instVars : [
		'label',
		'createdAt',
		'commands',
		'adornmentCommands',
		'messages',
		'adornmentMessages'
	],
	#category : 'GToolkit-Editor-Debugging',
	#package : 'GToolkit-Editor',
	#tag : 'Debugging'
}

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> adornmentCommands [
	<return: #Array of: #String>
	^ adornmentCommands
]

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> adornmentCommands: aCollection [
	adornmentCommands := aCollection asArray
]

{ #category : 'converting' }
GtTextEditorRecordersSnapshot >> adornmentDiffString [
	"Answer my adornment commands and adornment messages as one text, one entry per line."
	<return: #String>
	^ String
		streamContents: [ :aStream |
			self
				sectionNamed: 'Adornment Commands'
				entries: adornmentCommands
				on: aStream.
			aStream cr.
			self
				sectionNamed: 'Adornment Messages'
				entries: adornmentMessages
				on: aStream ]
]

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> adornmentMessages [
	<return: #Array of: #String>
	^ adornmentMessages
]

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> adornmentMessages: aCollection [
	adornmentMessages := aCollection asArray
]

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> commands [
	<return: #Array of: #String>
	^ commands
]

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> commands: aCollection [
	commands := aCollection asArray
]

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> createdAt [
	<return: #DateAndTime>
	^ createdAt
]

{ #category : 'converting' }
GtTextEditorRecordersSnapshot >> diffString [
	"Answer my commands and messages as one text, one entry per line.
	Those two lists are the complete ones; the adornment lists are subsets of them."
	<return: #String>
	^ String
		streamContents: [ :aStream |
			self sectionNamed: 'Commands' entries: commands on: aStream.
			aStream cr.
			self sectionNamed: 'Messages' entries: messages on: aStream ]
]

{ #category : 'views' }
GtTextEditorRecordersSnapshot >> gtAdornmentCommandsFor: aView [
	<gtView>
	adornmentCommands ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Adornment Commands';
		items: [ adornmentCommands ]
]

{ #category : 'views' }
GtTextEditorRecordersSnapshot >> gtAdornmentMessagesFor: aView [
	<gtView>
	adornmentMessages ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Adornment Messages';
		items: [ adornmentMessages ]
]

{ #category : 'views' }
GtTextEditorRecordersSnapshot >> gtCommandsFor: aView [
	<gtView>
	commands ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Commands';
		items: [ commands ]
]

{ #category : 'views' }
GtTextEditorRecordersSnapshot >> gtInfoFor: aView [
	<gtView>
	^ aView details
		title: 'Info';
		row: 'Label' value: [ label ] text: [ :aLabel | aLabel ];
		row: 'Taken at' value: [ createdAt ] text: [ :aTime | aTime printString ];
		row: 'Commands' value: [ commands ] text: [ :theEntries | theEntries size printString ];
		row: 'Adornment Commands'
			value: [ adornmentCommands ]
			text: [ :theEntries | theEntries size printString ];
		row: 'Messages' value: [ messages ] text: [ :theEntries | theEntries size printString ];
		row: 'Adornment Messages'
			value: [ adornmentMessages ]
			text: [ :theEntries | theEntries size printString ]
]

{ #category : 'views' }
GtTextEditorRecordersSnapshot >> gtMessagesFor: aView [
	<gtView>
	messages ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Messages';
		items: [ messages ]
]

{ #category : 'initialization' }
GtTextEditorRecordersSnapshot >> initialize [
	super initialize.
	label := ''.
	createdAt := DateAndTime now.
	commands := #().
	adornmentCommands := #().
	messages := #().
	adornmentMessages := #()
]

{ #category : 'testing' }
GtTextEditorRecordersSnapshot >> isEmpty [
	"Answer whether nothing was recorded at all, which is what a handle without
	the in-memory recorders enabled answers."
	<return: #Boolean>
	^ commands isEmpty and: [ messages isEmpty ]
]

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> label [
	<return: #String>
	^ label
]

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> label: aString [
	label := aString
]

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> messages [
	<return: #Array of: #String>
	^ messages
]

{ #category : 'accessing' }
GtTextEditorRecordersSnapshot >> messages: aCollection [
	messages := aCollection asArray
]

{ #category : 'converting' }
GtTextEditorRecordersSnapshot >> oneLineOf: aString [
	"Answer aString with its line breaks replaced by spaces, so that one recorded entry
	occupies exactly one line of a diff.
	Some entries really are multi line: ToEmbedderMessage derives Debug on the rust side,
	and TextChangedMessage prints its attribute trees as tables spanning several lines.
	Left as is, a single entry would align against several lines of the other side."
	<return: #String>
	| aResult |
	aResult := aString copyReplaceAll: String crlf with: ' '.
	aResult := aResult copyReplaceAll: String cr with: ' '.
	aResult := aResult copyReplaceAll: String lf with: ' '.
	^ aResult
]

{ #category : 'printing' }
GtTextEditorRecordersSnapshot >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: label;
		nextPutAll: ': ';
		print: commands size;
		nextPutAll: ' commands, ';
		print: messages size;
		nextPutAll: ' messages';
		nextPut: $)
]

{ #category : 'converting' }
GtTextEditorRecordersSnapshot >> sectionNamed: aName entries: aCollection on: aStream [
	"Write one named section of my entries, one entry per line.
	The name anchors the diff when several sections share one text."
	aStream nextPutAll: '--- '; nextPutAll: aName; nextPutAll: ' ('.
	aStream print: aCollection size.
	aStream nextPutAll: ') ---'; cr.
	aCollection do: [ :eachEntry | aStream nextPutAll: (self oneLineOf: eachEntry); cr ]
]
