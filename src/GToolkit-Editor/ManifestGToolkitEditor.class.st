"
I implement a text editor element that uses an exteral library.
"
Class {
	#name : 'ManifestGToolkitEditor',
	#superclass : 'PackageManifest',
	#category : 'GToolkit-Editor-Manifest',
	#package : 'GToolkit-Editor',
	#tag : 'Manifest'
}

{ #category : 'accessing' }
ManifestGToolkitEditor class >> mustOnlyDependOn [
	^ {'Brick-Editor'.
		'Brick-Glamorous'.
		'Brick-List-Ungrouped'.
		'Brick'.
		'Brick-Core'.
		'Bloc-Text'.
		'Bloc-Text-Rope'.
		'BlocPac-PullAndSlide'.
		'Bloc-Scripter'.
		'Bloc-Layout'.
		'Bloc-Compositor'.
		'Bloc'.
		'Beacon-Core'.
		'Beacon-ExtraSignals'.
		'Announcements-Core'.
		'Collections-Native'.
		'Collections-Sequenceable'.
		'Collections-Strings'.
		'Collections-Unordered'.
		'Collections-Weak'.
		'Collections-Support'.
		'Colors'.
		'FFI-Kernel'.
		'Futures'.
		'GToolkit-Boxer'.
		'GToolkit-Completer'.
		'GToolkit-Phlow'.
		'GToolkit-Phlow-Rust'.
		'GToolkit-Utility-System'.
		'Kernel'.
		'Multilingual-Encodings'.
		'System-Platforms'.
		'System-SessionManager'.
		'System-Time'.
		'Transcript-NonInteractive'.
		'UnifiedFFI'.
		'Winit'.
		'Zinc-Character-Encoding-Core'}
]
