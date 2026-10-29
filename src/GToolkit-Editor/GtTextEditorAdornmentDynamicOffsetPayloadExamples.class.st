"
I hold examples for {{gtClass:GtTextEditorAdornmentDynamicOffsetPayload}}.

My `#releasingPayloadMakesItInvalid` example creates a real payload from a real {{gtClass:GtTextEditorHandle}}, confirms it starts valid, releases it, and confirms it becomes invalid - a smoke test for the explicit release discipline that {{gtMethod:GtTextEditorElement>>#paintMeAndChildrenOn:offset:}} relies on to avoid leaking one payload (and the strong {{gtClass:GtTextEditorHandle}} clone it holds) per paint of an adorned element.
"
Class {
	#name : 'GtTextEditorAdornmentDynamicOffsetPayloadExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples' }
GtTextEditorAdornmentDynamicOffsetPayloadExamples >> releasingPayloadMakesItInvalid [
	<gtExample>
	<return: #Boolean>
	| semaphoreIndex payload handle wasValidBeforeRelease |
	semaphoreIndex := GtTextEditorProcess current semaphoreIndex.
	GtTextEditorEmbedder
		forSemaphoreIndex: semaphoreIndex
		during: [ :pharoEmbedder | 
			handle := GtTextEditorHandle forEmbedder: pharoEmbedder.
			payload := GtTextEditorAdornmentDynamicOffsetPayload
				fromEditorHandle: handle
				adornmentTag: 1.
			wasValidBeforeRelease := payload isValid.
			payload release.
			handle release ].
	self assert: wasValidBeforeRelease.
	self assert: payload isValid not.
	^ payload isValid
]
