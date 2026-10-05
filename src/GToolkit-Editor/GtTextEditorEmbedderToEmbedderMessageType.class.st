Class {
	#name : 'GtTextEditorEmbedderToEmbedderMessageType',
	#superclass : 'GtExternalEnumeration',
	#classVars : [
		'ActiveCaretMoved',
		'AdornmentAttributesAdded',
		'AdornmentAttributesGone',
		'AdornmentAttributesRemoved',
		'AdornmentAttributesVisible',
		'AdornmentMeasured',
		'CaretsChanged',
		'CursorReachedBoundary',
		'LayoutReady',
		'MeasureAdornment',
		'PerformAction',
		'ScrollEdgeReached',
		'StyledTextRejected',
		'TextChanged',
		'TextCompletionRequest',
		'TextEvent',
		'TextStylingRequest',
		'Unknown'
	],
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> ActiveCaretMoved [
	"This method was automatically generated"
	^ ActiveCaretMoved
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> AdornmentAttributesAdded [
	"This method was automatically generated"
	^ AdornmentAttributesAdded
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> AdornmentAttributesGone [
	"This method was automatically generated"
	^ AdornmentAttributesGone
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> AdornmentAttributesRemoved [
	"This method was automatically generated"
	^ AdornmentAttributesRemoved
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> AdornmentAttributesVisible [
	"This method was automatically generated"
	^ AdornmentAttributesVisible
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> AdornmentMeasured [
	"This method was automatically generated"
	^ AdornmentMeasured
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> CaretsChanged [
	"This method was automatically generated"
	^ CaretsChanged
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> CursorReachedBoundary [
	"This method was automatically generated"
	^ CursorReachedBoundary
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> LayoutReady [
	"This method was automatically generated"
	^ LayoutReady
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> MeasureAdornment [
	"This method was automatically generated"
	^ MeasureAdornment
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> PerformAction [
	"This method was automatically generated"
	^ PerformAction
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> ScrollEdgeReached [
	"This method was automatically generated"
	^ ScrollEdgeReached
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> StyledTextRejected [
	"This method was automatically generated"
	^ StyledTextRejected
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> TextChanged [
	"This method was automatically generated"
	^ TextChanged
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> TextCompletionRequest [
	"This method was automatically generated"
	^ TextCompletionRequest
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> TextEvent [
	"This method was automatically generated"
	^ TextEvent
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> TextStylingRequest [
	"This method was automatically generated"
	^ TextStylingRequest
]

{ #category : 'accessing enum' }
GtTextEditorEmbedderToEmbedderMessageType class >> Unknown [
	"This method was automatically generated"
	^ Unknown
]

{ #category : 'accessing' }
GtTextEditorEmbedderToEmbedderMessageType class >> externalDeclaration [
	"Mirror of the rust ToEmbedderMessageType enumeration in libeditor/src/messages.rs.
	The embedder dispatches incoming messages by the numeric value of this enumeration, so a
	variant must only ever be appended here and there, never inserted or reordered."
	^ #(
		Unknown,
		LayoutReady,
		MeasureAdornment,
		AdornmentMeasured,
		AdornmentAttributesAdded,
		AdornmentAttributesRemoved,
		ActiveCaretMoved,
		CaretsChanged,
		TextEvent,
		TextChanged,
		TextCompletionRequest,
		TextStylingRequest,
		PerformAction,
		ScrollEdgeReached,
		CursorReachedBoundary,
		AdornmentAttributesVisible,
		AdornmentAttributesGone,
		StyledTextRejected,
	)
]

{ #category : 'ffi' }
GtTextEditorEmbedderToEmbedderMessageType class >> externalType [
	^ FFIUInt8 new
]
