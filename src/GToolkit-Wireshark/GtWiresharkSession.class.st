Class {
	#name : 'GtWiresharkSession',
	#superclass : 'Object',
	#instVars : [
		'allPackets',
		'wiresharkFile'
	],
	#category : 'GToolkit-Wireshark',
	#package : 'GToolkit-Wireshark'
}

{ #category : 'accessing' }
GtWiresharkSession >> gtPacketsFor: aView [
	<gtView>

	allPackets ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Packets';
		priority: 20;
		object: [ allPackets ];
		view: #gtItemsFor:
]

{ #category : 'initialization' }
GtWiresharkSession >> initializeWithPackets: aCollection [

	allPackets := aCollection
]

{ #category : 'private' }
GtWiresharkSession >> load [
	| jsonObject |

	jsonObject := wiresharkFile asFileReference
			readStreamDo: [ :stream | STONJSON fromStream: stream ].
	allPackets := jsonObject
			collectWithIndex: [ :each :index | 
				GtWiresharkDissectedPacket new
					parent: jsonObject;
					index: index;
					rawData: each ].
]

{ #category : 'accessing' }
GtWiresharkSession >> packets [

	^ allPackets ifNil: [ self load. allPackets ]
]

{ #category : 'accessing' }
GtWiresharkSession >> select: aBlock [

	^ self class new initializeWithPackets:
		(allPackets select: aBlock)
]

{ #category : 'selecting' }
GtWiresharkSession >> selectWithPort: anInteger [

	^ self select: [ :aPacket |
		aPacket srcPort = anInteger or: [ aPacket dstPort = anInteger ] ]
]

{ #category : 'accessing' }
GtWiresharkSession >> wiresharkFile [
	^ wiresharkFile
]

{ #category : 'accessing' }
GtWiresharkSession >> wiresharkFile: anObject [
	wiresharkFile := anObject
]
