Class {
	#name : 'GtRrMsgPackMessage',
	#superclass : 'Object',
	#instVars : [
		'rawData',
		'sourceRange'
	],
	#category : 'GToolkit-Wireshark',
	#package : 'GToolkit-Wireshark'
}

{ #category : 'accessing' }
GtRrMsgPackMessage >> bindings [
	| src bindings |

	src := rawData at: #bindings ifAbsent: [ ^ nil ].
	bindings := Dictionary new.
	src keysAndValuesDo: [ :key :value |
		bindings
			at: key
			put: (MpDecoder decode: value) ].
	^ bindings.
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> commandId [

	^ rawData at: 'commandId' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> gtBindingsFor: aView [
	<gtView>
	
	self bindings ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Bindings';
		priority: 25;
		object: [ self bindings ];
		view: #gtLiveFor:
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> gtRawDataFor: aView [
	<gtView>

	^ aView forward
		title: 'Raw Data';
		priority: 40;
		object: [ rawData ];
		view: #gtLiveFor:
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> gtStatementsFor: aView [
	<gtView>
	
	self statements ifNil: [ ^ aView empty ].
	^ aView text
		title: 'Statements';
		priority: 20;
		text: [ self statements ]
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> id [

	^ rawData at: 'id' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> printOn: aStream [

	self commandId ifNil: [ ^ super printOn: aStream ].
	aStream
		<< 'commandId: ';
		<< self commandId.
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> rawData [
	^ rawData
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> rawData: anObject [
	rawData := anObject
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> sourceRange [
	"Answer the range of bytes from the wireshark dump that contain the receiver"
	<return: #Interval>

	^ sourceRange
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> sourceRange: anInterval [

	sourceRange := anInterval
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> statements [

	^ rawData at: 'statements' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> type [

	^ rawData at: 'type'
]

{ #category : 'accessing' }
GtRrMsgPackMessage >> value [
	| data |

	data := rawData at: #value
		ifAbsent: [ ^ self ].
	^ MpDecoder decode: data
]
