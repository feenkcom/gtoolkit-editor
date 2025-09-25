Class {
	#name : #GtTextEditorAttribute,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'as yet unclassified' }
GtTextEditorAttribute class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'as yet unclassified' }
GtTextEditorAttribute class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void attribute_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorAttribute >> asAttribute [
	self class = GtTextEditorAttribute
		ifTrue: [ ^ self ].
		
	^ GtTextEditorAttribute fromNativeHandle: self primAsAttribute
]

{ #category : #'as yet unclassified' }
GtTextEditorAttribute >> asAttributeDuring: aBlock [
	self class = GtTextEditorAttribute
		ifTrue: [ ^ aBlock value: self ].
		
	^ GtTextEditorAttribute
		fromNativeHandle: self primAsAttribute
		during: aBlock
]

{ #category : #'as yet unclassified' }
GtTextEditorAttribute >> primAsAttribute [
	self subclassResponsibility.

	"self ffiCall: #(void* replacing_attribute_into_attribute(self))"
]
