Class {
	#name : 'GtWiresharkObject',
	#superclass : 'Object',
	#instVars : [
		'rawData'
	],
	#category : 'GToolkit-Wireshark',
	#package : 'GToolkit-Wireshark'
}

{ #category : 'ui' }
GtWiresharkObject >> gtRawDataFor: aView [
	<gtView>

	^ aView forward
		title: 'Raw Data';
		priority: 40;
		object: [ rawData ];
		view: #gtLiveFor:
]

{ #category : 'accessing' }
GtWiresharkObject >> rawData [
	^ rawData
]

{ #category : 'accessing' }
GtWiresharkObject >> rawData: anObject [
	rawData := anObject
]
