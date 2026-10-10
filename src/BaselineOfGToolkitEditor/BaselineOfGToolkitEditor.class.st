Class {
	#name : 'BaselineOfGToolkitEditor',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGToolkitEditor',
	#package : 'BaselineOfGToolkitEditor'
}

{ #category : 'loading' }
BaselineOfGToolkitEditor class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gtoolkit-editor' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : 'baseline' }
BaselineOfGToolkitEditor >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GToolkitPhlowForRust' with: [
				spec repository: 'github://feenkcom/gt4phlow-rs:v0.6.23/src' ].
		spec
			baseline: 'Brick' with: [
				spec repository: 'github://feenkcom/Brick:v0.9.159/src' ].
		spec
			baseline: 'GToolkitCompleter' with: [
				spec repository: 'github://feenkcom/gtoolkit-completer:v0.9.161/src' ].
		spec
			baseline: 'GToolkitPhlow' with: [
				spec repository: 'github://feenkcom/gtoolkit-phlow:v0.9.197/src' ].
		spec
			baseline: 'Winit' with: [
				spec repository: 'github://feenkcom/gtoolkit-glutin:v0.8.164/src' ].

		spec package: 'GToolkit-Editor' with: [
			spec requires: #(#GToolkitPhlowForRust #Brick #GToolkitCompleter #GToolkitPhlow #Winit) ].
	]
]
