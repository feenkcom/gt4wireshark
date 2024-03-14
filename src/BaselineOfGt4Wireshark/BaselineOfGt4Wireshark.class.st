Class {
	#name : #BaselineOfGt4Wireshark,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Wireshark
}

{ #category : #loading }
BaselineOfGt4Wireshark class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gt4wireshark' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baselines }
BaselineOfGt4Wireshark >> baseline: spec [
	<baseline>

	| packages |

	spec for: #common do: [ 
		spec blessing: #baseline.
		packages := #('GToolkit-Wireshark' 'GToolkit-Wireshark-RemoteRunner').
		packages do: [ :package |
			spec package: package ].
		spec
			group: 'Core' with: packages;
			group: 'all' with: #(Core);
			group: 'default' with: #(Core) ]
]
