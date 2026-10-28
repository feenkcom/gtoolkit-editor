"
I hold examples proving the {{gtClass:GtTextEditorHandle}} release lifecycle.

My #releasingHandlesStopsTheEditorOsThreads example proves (via OS thread counting, `ps -M -p <pid>`) that releasing a {{gtClass:GtTextEditorHandle}} actually shuts down its Rust-side ""Editor"" OS thread and the two debouncer worker threads it owns, rather than leaking them forever. macOS only: `ps -M` is BSD/macOS-specific (Linux uses different flags, e.g. `ps -eLf`), and `ps` does not exist on Windows at all, which is a real target platform for this editor. The example checks `OSPlatform current isMacOS` first and returns early (0) on any other platform, before running any `ps` command.

This is expected to FAIL right now: the currently loaded editor library still has the bug (the editor thread holds its own strong clone of the handle for its entire lifetime, so nothing ever told it to stop). The fix adds an explicit `EditorHandle::stop()` that sends the stop command directly on the command channel, independent of how many strong clones exist, called from `editor_handle_release` before the handle drops (gtoolkit-editor-rs, commit 325e9de). It is implemented and tested on the Rust side but not yet compiled into the library this image currently links. Re-run this example after the rebuilt library is loaded; it should then pass (delta of 0 OS threads per released handle instead of 3).
"
Class {
	#name : 'GtTextEditorHandleLifecycleExamples',
	#superclass : 'Object',
	#category : 'GToolkit-Editor-Examples',
	#package : 'GToolkit-Editor',
	#tag : 'Examples'
}

{ #category : 'examples' }
GtTextEditorHandleLifecycleExamples >> releasingHandlesStopsTheEditorOsThreads [
	<gtExample>
	<return: #SmallInteger>
	| numberOfHandles processId threadsBefore threadsAfter semaphoreIndex handles |
	OSPlatform current isMacOS ifFalse: [ ^ 0 ].

	numberOfHandles := 3.
	processId := LibC uniqueInstance currentProcessId asString.
	threadsBefore := (LibC resultOfCommand: 'ps -M -p ', processId) lines size.

	handles := OrderedCollection new.
	semaphoreIndex := GtTextEditorProcess current semaphoreIndex.
	numberOfHandles timesRepeat: [
		GtTextEditorEmbedder
			forSemaphoreIndex: semaphoreIndex
			during: [ :pharoEmbedder |
				handles add: (GtTextEditorHandle forEmbedder: pharoEmbedder) ] ].

	handles do: [ :each | each release ].

	"Give each editor thread a fair chance to actually process RuntimeCommand::Stop and exit."
	(Delay forMilliseconds: 1000) wait.

	threadsAfter := (LibC resultOfCommand: 'ps -M -p ', processId) lines size.

	self assert: threadsAfter equals: threadsBefore.

	^ threadsAfter - threadsBefore
]
