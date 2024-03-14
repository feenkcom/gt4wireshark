Class {
	#name : #GtWiresharkIp,
	#superclass : #GtWiresharkObject,
	#category : #'GToolkit-Wireshark'
}

{ #category : #accessing }
GtWiresharkIp >> ipAddress [

	^ rawData at: 'ip.addr'
]

{ #category : #accessing }
GtWiresharkIp >> srcHost [

	^ rawData at: 'ip.src_host'
]
