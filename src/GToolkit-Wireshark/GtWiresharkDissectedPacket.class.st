Class {
	#name : 'GtWiresharkDissectedPacket',
	#superclass : 'GtWiresharkObject',
	#instVars : [
		'parent',
		'index'
	],
	#category : 'GToolkit-Wireshark',
	#package : 'GToolkit-Wireshark'
}

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> dstPort [

	^ self tcp dstport
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> frame [

	^ self layers frame
]

{ #category : 'ui' }
GtWiresharkDissectedPacket >> gtPayloadAsciiFor: aView [
	<gtView>
	
	self payloadAscii ifNil: [ ^ aView empty ].
	^ aView text
		title: 'Payload (ascii)';
		priority: 20;
		text: [ self payloadAscii ]
]

{ #category : 'ui' }
GtWiresharkDissectedPacket >> gtPayloadFor: aView [
	<gtView>
	
	self payload ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Payload';
		priority: 20;
		object: [ self payload ];
		view: #gtHexDumpFor:
]

{ #category : 'ui' }
GtWiresharkDissectedPacket >> gtPayloadMsgPackFor: aView [
	<gtView>
	
	self payloadMsgPack ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Payload (MsgPack)';
		priority: 20;
		object: [ self payloadMsgPack rawData ];
		view: #gtLiveFor:
]

{ #category : 'ui' }
GtWiresharkDissectedPacket >> gtStatementsFor: aView [
	<gtView>

	(self payloadMsgPack rawData includesKey: 'value') ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Payload Value';
		priority: 30;
		object: [ self payloadMsgPack ];
		view: #gtDecodedValueFor:
]

{ #category : 'ui' }
GtWiresharkDissectedPacket >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 10;
		items: [ self summaryAttributes ];
		column: #Attribute text: [ :item | item first ];
		column: #Value text: [ :item | item second ];
		send: [ :item | item third ];
		actionUpdateButton
]

{ #category : 'testing' }
GtWiresharkDissectedPacket >> hasPayload [

	^ self tcp rawData includesKey: 'tcp.payload'
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> index [
	^ index
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> index: anObject [
	index := anObject
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> ip [

	^ self layers ip
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> ipAddress [

	^ self ip ipAddress
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> layers [

	^ GtWiresharkPacketLayers new rawData: ((rawData at: #_source) at: #layers)
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> parent [
	^ parent
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> parent: anObject [
	parent := anObject
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> payload [

	^ [ self tcp payload ]
		on: Error
		do: [ :ex | nil ]
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> payloadAscii [

	^ [ self tcp payloadAscii ]
		on: Error
		do: [ :ex | nil ]
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> payloadMsgPack [

	^ [ self tcp payloadMsgPack ]
		on: Error
		do: [ :ex | nil ]
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> payloadSize [

	^ self tcp payloadSize
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> printOn: aStream [
	| time |

	rawData ifNil: [ ^ super printOn: aStream ].

	index ifNotNil:
		[ aStream 
			print: index;
			<< ': ' ].
	time := [ self frame timeUtc ]
		on: Error
		do: [ :ex | nil ].
	aStream print: time.
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> srcHost [

	^ self ip srcHost
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> srcPort [

	^ self tcp srcport
]

{ #category : 'ui' }
GtWiresharkDissectedPacket >> summaryAttributes [
	| attrs |

	attrs := OrderedCollection new.
	self ipAddress ifNotNil: [ :v |
		attrs add: { 'Destination IP address'. v. self ip. } ].
	self dstPort ifNotNil: [ :v |
		attrs add: { 'Destination Port'. v. self tcp. } ].
	self srcHost ifNotNil: [ :v |
		attrs add: { 'Source IP Address'. v. self ip. } ].
	self srcPort ifNotNil: [ :v |
		attrs add: { 'Source Port'. v. self tcp. } ].
	attrs add: { 'Payload size'. self payloadSize. self tcp. }.
	^ attrs
]

{ #category : 'accessing' }
GtWiresharkDissectedPacket >> tcp [

	^ self layers tcp
]
