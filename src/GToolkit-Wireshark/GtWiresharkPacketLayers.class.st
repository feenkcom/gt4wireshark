Class {
	#name : #GtWiresharkPacketLayers,
	#superclass : #GtWiresharkObject,
	#category : #'GToolkit-Wireshark'
}

{ #category : #accessing }
GtWiresharkPacketLayers >> frame [

	^ GtWiresharkFrame new rawData: (rawData at: #frame)
]

{ #category : #accessing }
GtWiresharkPacketLayers >> ip [

	^ GtWiresharkIp new rawData: (rawData at: #ip)
]

{ #category : #accessing }
GtWiresharkPacketLayers >> tcp [

	^ GtWiresharkTcp new rawData: (rawData at: #tcp)
]
