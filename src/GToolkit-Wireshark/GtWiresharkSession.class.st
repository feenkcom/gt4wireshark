Class {
	#name : #GtWiresharkSession,
	#superclass : #Object,
	#instVars : [
		'allPackets',
		'wiresharkFile'
	],
	#category : #'GToolkit-Wireshark'
}

{ #category : #accessing }
GtWiresharkSession >> gtPacketsFor: aView [
	<gtView>

	allPackets ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Packets';
		priority: 20;
		object: [ allPackets ];
		view: #gtItemsFor:
]

{ #category : #private }
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

{ #category : #accessing }
GtWiresharkSession >> wiresharkFile [
	^ wiresharkFile
]

{ #category : #accessing }
GtWiresharkSession >> wiresharkFile: anObject [
	wiresharkFile := anObject
]
