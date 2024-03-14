Class {
	#name : #GtWiresharkTcp,
	#superclass : #GtWiresharkObject,
	#category : #'GToolkit-Wireshark'
}

{ #category : #accessing }
GtWiresharkTcp >> dstport [

	^ (rawData at: 'tcp.dstport') asNumber
]

{ #category : #accessing }
GtWiresharkTcp >> payload [

	^ ByteArray readHexFrom: ((rawData at: #'tcp.payload') copyReplaceAll: ':' with: '')
]

{ #category : #accessing }
GtWiresharkTcp >> payloadAscii [

	^ self payload asString
]

{ #category : #accessing }
GtWiresharkTcp >> payloadMsgPack [

	^ MpDecoder decode: self payload
]

{ #category : #accessing }
GtWiresharkTcp >> payloadSize [

	^ [ self payload size ]
		on: Error
		do: [ :ex | 0 ]
]

{ #category : #accessing }
GtWiresharkTcp >> srcport [

	^ (rawData at: 'tcp.srcport') asNumber
]
