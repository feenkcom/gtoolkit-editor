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

		spec package: 'GToolkit-Editor' with: [
			spec requires: #(#GToolkitPhlowForRust) ].
	]
]
