Class {
	#name : #BaselineOfGToolkitEditor,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitEditor
}

{ #category : #loading }
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

{ #category : #baseline }
BaselineOfGToolkitEditor >> baseline: spec [
	<baseline>
		spec 
			baseline: 'GToolkitPhlowForRust' with: [
				spec repository: 'github://feenkcom/gt4phlow-rs:main/src' ].
		^ spec for: #common do: [
			spec package: 'GToolkit-Editor' with: [
				spec requires: #('GToolkitPhlowForRust'). ]
		]
]
