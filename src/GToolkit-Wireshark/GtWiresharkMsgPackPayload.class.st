Class {
	#name : 'GtWiresharkMsgPackPayload',
	#superclass : 'GtWiresharkObject',
	#category : 'GToolkit-Wireshark',
	#package : 'GToolkit-Wireshark'
}

{ #category : 'ui' }
GtWiresharkMsgPackPayload >> gtDecodedValueFor: aView [
	<gtView>

	[ self leMpValue ]
		on: Error
		do: [ :ex | ^ aView empty ].
	^ aView forward
		title: 'Value';
		priority: 30;
		object: [ self leMpValue ];
		view: #gtLiveFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the value'
			action: [ :aButton | aButton phlow spawnObject: self leMpValue ]
]

{ #category : 'ui' }
GtWiresharkMsgPackPayload >> gtStatementsFor: aView [
	<gtView>

	(rawData includesKey: 'statements') ifFalse: [ ^ aView empty ].
	^ aView text
		title: 'Statements';
		priority: 30;
		text: [ rawData at: 'statements' ]
]

{ #category : 'accessing' }
GtWiresharkMsgPackPayload >> leMpValue [

	^ LeJsonV4 uniqueInstance deserialize: self mpValue readStream
]

{ #category : 'accessing' }
GtWiresharkMsgPackPayload >> mpValue [

	^ MpDecoder decode: (rawData at: 'value')
]
