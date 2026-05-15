Class {
	#name : 'GtTextEditorScrollByResult',
	#superclass : 'FFIExternalStructure',
	#classVars : [
		'OFFSET_DELTA',
		'OFFSET_EDGE',
		'OFFSET_RESULTTYPE',
		'OFFSET_VELOCITY'
	],
	#category : 'GToolkit-Editor-Messages',
	#package : 'GToolkit-Editor',
	#tag : 'Messages'
}

{ #category : 'field definition' }
GtTextEditorScrollByResult class >> fieldsDesc [
	"self rebuildFieldAccessors"
	^ #(
		GtTextEditorScrollByResultType resultType;
		GtTextEditorScrollEdgeType edge;
		float64 delta;
		float64 velocity;
	)
]

{ #category : 'accessing - structure variables' }
GtTextEditorScrollByResult >> delta [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_DELTA
]

{ #category : 'accessing - structure variables' }
GtTextEditorScrollByResult >> delta: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_DELTA put: anObject
]

{ #category : 'accessing - structure variables' }
GtTextEditorScrollByResult >> edge [
	"This method was automatically generated"
	^GtTextEditorScrollEdgeType fromInteger: (handle unsignedByteAt: OFFSET_EDGE)
]

{ #category : 'accessing - structure variables' }
GtTextEditorScrollByResult >> edge: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: OFFSET_EDGE put: anObject value
]

{ #category : 'accessing - structure variables' }
GtTextEditorScrollByResult >> resultType [
	"This method was automatically generated"
	^GtTextEditorScrollByResultType fromInteger: (handle unsignedByteAt: OFFSET_RESULTTYPE)
]

{ #category : 'accessing - structure variables' }
GtTextEditorScrollByResult >> resultType: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: OFFSET_RESULTTYPE put: anObject value
]

{ #category : 'accessing - structure variables' }
GtTextEditorScrollByResult >> velocity [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_VELOCITY
]

{ #category : 'accessing - structure variables' }
GtTextEditorScrollByResult >> velocity: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_VELOCITY put: anObject
]
