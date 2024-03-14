Class {
	#name : #GtRrWiresharkSession,
	#superclass : #Object,
	#instVars : [
		'wsharkFile',
		'clientIp',
		'serverIp',
		'toServerMessages',
		'toClientMessages'
	],
	#category : #'GToolkit-Wireshark-RemoteRunner'
}

{ #category : #accessing }
GtRrWiresharkSession >> clientIp [
	^ clientIp
]

{ #category : #accessing }
GtRrWiresharkSession >> clientIp: anObject [
	clientIp := anObject
]

{ #category : #private }
GtRrWiresharkSession >> extract: allPackets from: srcAddress to: dstAddress [
	| tcpData pharoLinkMessages tcpStream tcpPackets decoder |

	tcpPackets := allPackets select: [ :each | 
		each ipAddress = dstAddress and: [ each srcHost = srcAddress ] ].
	tcpData := ByteArray
			streamContents: [ :stream | 
				tcpPackets
					do: [ :packet | packet payload ifNotNil: [ :payload | stream nextPutAll: payload ] ] ].
	pharoLinkMessages := OrderedCollection new.
	tcpStream := tcpData readStream.
	decoder := MpDecoder on: tcpStream.
	[ decoder atEnd ] whileFalse: [ | sourceStart sourceEnd rawData |
		sourceStart := tcpStream position.
		rawData := decoder next.
		sourceEnd := tcpStream position.
		pharoLinkMessages add: 
		(GtRrMsgPackMessage new 
			rawData: rawData;
			sourceRange: (sourceStart to: sourceEnd)) ].
	^ pharoLinkMessages
]

{ #category : #accessing }
GtRrWiresharkSession >> gtToClientFor: aView [
	<gtView>

	toClientMessages ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'To Client';
		priority: 20;
		object: [ toClientMessages ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtRrWiresharkSession >> gtToServerFor: aView [
	<gtView>

	toServerMessages ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'To Server';
		priority: 20;
		object: [ toServerMessages ];
		view: #gtItemsFor:
]

{ #category : #private }
GtRrWiresharkSession >> load [
	| jsonObject allPackets |

	jsonObject := wsharkFile asFileReference
			readStreamDo: [ :stream | STONJSON fromStream: stream ].
	allPackets := jsonObject
			collectWithIndex: [ :each :index | 
				GtWiresharkDissectedPacket new
					parent: jsonObject;
					index: index;
					rawData: each ].
	toClientMessages := self extract: allPackets from: serverIp to: clientIp.
	toServerMessages := self extract: allPackets from: clientIp to: serverIp.
]

{ #category : #accessing }
GtRrWiresharkSession >> paired [
	| dict |

	dict := Dictionary new.
	toServerMessages do: [ :toServerMessage | | id toClientMessage |
		toServerMessage type = 'ENQUEUE' ifTrue:
			[ id := toServerMessage commandId.
			toClientMessage := toClientMessages
				detect: [ :each | each id = id ]
				ifNone: [ nil ].
			dict at: id put: toServerMessage -> toClientMessage ] ].
	^ dict
]

{ #category : #accessing }
GtRrWiresharkSession >> serverIp [
	^ serverIp
]

{ #category : #accessing }
GtRrWiresharkSession >> serverIp: anObject [
	serverIp := anObject
]

{ #category : #accessing }
GtRrWiresharkSession >> wiresharkFile [
	^ wsharkFile
]

{ #category : #accessing }
GtRrWiresharkSession >> wiresharkFile: aFileReference [

	wsharkFile := aFileReference.
]
