Class {
	#name : #GtWiresharkFrame,
	#superclass : #GtWiresharkObject,
	#category : #'GToolkit-Wireshark'
}

{ #category : #accessing }
GtWiresharkFrame >> timeUtc [

	^ DateAndTime readFrom: (((rawData at: 'frame.time_utc') allButLast: 4), '+00:00') readStream
]
