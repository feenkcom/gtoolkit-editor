"
I wrap one owned native `AdornmentDynamicOffsetPayload` reference (Rust side, {{gtClass:GtTextEditorHandle}} package), created by {{gtMethod:GtTextEditorHandle>>#primCreateAdornmentDynamicOffset:}}.

A compositor layer that follows an adorned child element's on-screen position (see {{gtClass:BlCompositionDynamicOffsetLayer}}) needs to query that position through native code on every paint. Each paint of an adorned child creates one such payload. The native side clones its own reference for the layer's lifetime; it does not take ownership of the one it is given. So the caller (my instance) must release its own reference once the native call that hands off the payload returns, instead of leaking it.

I follow the usual {{gtClass:GtBoxerExternalObject}} discipline: explicit `#release` (which calls `primRelease:`, i.e. `adornment_dynamic_offset_payload_release`), with a GC-triggered finalizer as a fallback. See {{gtMethod:GtTextEditorElement>>#paintMeAndChildrenOn:offset:}} for the one call site, which releases me right after use.
"
Class {
	#name : 'GtTextEditorAdornmentDynamicOffsetPayload',
	#superclass : 'GtBoxerValueBox',
	#category : 'GToolkit-Editor-FFI',
	#package : 'GToolkit-Editor',
	#tag : 'FFI'
}

{ #category : 'ffi library' }
GtTextEditorAdornmentDynamicOffsetPayload class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : 'instance creation' }
GtTextEditorAdornmentDynamicOffsetPayload class >> fromEditorHandle: anEditorHandle adornmentTag: anAdornmentTag [
	^ self fromNativeHandle: (anEditorHandle primCreateAdornmentDynamicOffset: anAdornmentTag)
]

{ #category : 'ffi library' }
GtTextEditorAdornmentDynamicOffsetPayload class >> primRelease: aHandle [
	self ffiCall: #(void adornment_dynamic_offset_payload_release(void* aHandle))
]
