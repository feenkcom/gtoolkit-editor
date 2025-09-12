Class {
	#name : #GtTextEditorRunTree,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Editor-Model'
}

{ #category : #'library path' }
GtTextEditorRunTree class >> ffiLibrary [
	^ GtTextEditorLibrary uniqueInstance
]

{ #category : #'private - ffi' }
GtTextEditorRunTree class >> primCreate [
	^ self ffiCall: #(void* run_tree_new())
]

{ #category : #'private - ffi' }
GtTextEditorRunTree class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void run_tree_release(void* aHandle))
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> addAttribute: anEditorAttribute start: aStart end: anEnd [
	self
		primAddAttribute: anEditorAttribute
		start: aStart
		end: anEnd
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> attributeRuns [
	^ GtTextEditorRunTreeRuns fromNativeHandle: (self
		primAttributeRunsStart: 0
		end: self size
		offset: 0)
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> flattenedReplacementRuns [
	^ GtTextEditorFlattenedReplacementRuns fromNativeHandle: (self
		primFlattenedReplacementRunsStart: 0
		end: self size
		offset: 0)
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> gtArrowDownElement [
	^ (BrGlamorousVectorIcons smallDownwards asElement
		background: BlTheme default default lightBorderColor)
			asScalableElement size: 20@20
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> gtAttributeRunsElement [
	| allRuns |
	allRuns := self attributeRuns asArray.
	^ self gtReplacementRunsElementOf: allRuns
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> gtFlattenReplacementRunsElement [
	| allRuns |
	allRuns := self flattenedReplacementRuns asArray.
	^ self gtReplacementRunsElementOf: allRuns
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> gtReplacementRunsElement [
	| allRuns |
	allRuns := self replacementRuns asArray.
	^ self gtReplacementRunsElementOf: allRuns
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> gtReplacementRunsElementOf: allRuns [
	| runElements size container |
	container := BrVerticalPane new
			cellSpacing: 5;
			padding: (BlInsets left: 5 right: 5);
			hMatchParent;
			vFitContent.

	size := self size.

	runElements := allRuns
			collect: [ :eachRun | 
				| left right |
				left := (eachRun start / size) asFloat.
				right := (eachRun end / size) asFloat.

				BlElement new
					geometry: (BlNormalizedPolylineGeometry
							vertices: {left @ 0.
									left @ 1.
									right @ 1.
									right @ 0});
					height: 10;
					border: (BlBorder paint: Color black width: 1);
					constraintsDo: [ :c | c horizontal matchParent ] ].

	container addChildren: runElements.

	^ container
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> gtReplacementRunsFor: aView [
	<gtView>
	
	^ aView explicit
		title: 'Replacements';
		priority: 3;
		stencil: [
			BrVerticalPane new
				hMatchParent;
				vFitContent;
				alignTopCenter;
				cellSpacing: 10;
				padding: (BlInsets all: 10);
				addChildren: {
					self gtReplacementRunsLabel: 'Attribute runs'.
					self gtAttributeRunsElement.
					self gtArrowDownElement.
					self gtReplacementRunsLabel: 'Replacement attributes'.
					self gtReplacementRunsElement.
					self gtArrowDownElement.
					self gtReplacementRunsLabel: 'Flattened replacement attributes'.
					self gtFlattenReplacementRunsElement
				}
		]
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> gtReplacementRunsLabel: aString [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		text: aString
]

{ #category : #'private - ffi' }
GtTextEditorRunTree >> primAddAttribute: anEditorAttribute start: aStart end: anEnd [
	self ffiCall: #(void run_tree_add_attribute(
		self,
		void* anEditorAttribute,
		size_t aStart,
		size_t anEnd))
]

{ #category : #'private - ffi' }
GtTextEditorRunTree >> primAttributeRunsStart: aStart end: anEnd offset: anOffset [
	^ self ffiCall: #(void* run_tree_runs(
		self,
		size_t aStart,
		size_t anEnd,
		size_t anOffset
	))
]

{ #category : #'private - ffi' }
GtTextEditorRunTree >> primFlattenedReplacementRunsStart: aStart end: anEnd offset: anOffset [
	^ self ffiCall: #(void* run_tree_flatten_replacement_runs(
		self,
		size_t aStart,
		size_t anEnd,
		size_t anOffset
	))
]

{ #category : #'private - ffi' }
GtTextEditorRunTree >> primLen [
	self ffiCall: #(size_t run_tree_len(self))
]

{ #category : #'private - ffi' }
GtTextEditorRunTree >> primReplacementRunsStart: aStart end: anEnd offset: anOffset [
	^ self ffiCall: #(void* run_tree_replacement_runs(
		self,
		size_t aStart,
		size_t anEnd,
		size_t anOffset
	))
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> replacementRuns [
	^ GtTextEditorReplacementRuns fromNativeHandle: (self
		primReplacementRunsStart: 0
		end: self size
		offset: 0)
]

{ #category : #'as yet unclassified' }
GtTextEditorRunTree >> size [
	^ self primLen
]
