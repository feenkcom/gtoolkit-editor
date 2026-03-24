Class {
	#name : 'GtTextEditorEmbedderToEmbedderMessageType',
	#superclass : 'GtExternalEnumeration',
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'ffi' }
GtTextEditorEmbedderToEmbedderMessageType class >> externalDeclaration [
	^ #(
		Unknown,
		LayoutReady,
		MeasureAdornment,
		AdornmentMeasured,
		TextChanged,
		TextCompletionRequest,
		TextStylingRequest,
	)
]

{ #category : 'ffi' }
GtTextEditorEmbedderToEmbedderMessageType class >> externalType [
	^ FFIUInt8 new
]
