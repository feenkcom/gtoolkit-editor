"
I am an announcement that exists only so the editor examples have one to announce.

${class:GtTextEditorTimelineRecorder}$ needs no reference to any announcement class, which is what lets it observe a coder view model without `GToolkit-Editor` depending on the packages that define its announcements. An example that announced a coder announcement would create exactly the dependency the recorder is built to avoid, so the examples use `Announcement` itself where anything will do, and me where they need a second, distinct class to show that a narrowed observation ignores everything else.
"
Class {
	#name : 'GtTextEditorExampleAnnouncement',
	#superclass : 'Announcement',
	#category : 'GToolkit-Editor',
	#package : 'GToolkit-Editor'
}
