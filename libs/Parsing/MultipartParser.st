Namespace current: Parsing [

	Object subclass: MultipartParser [
		| stream headersReader maxMemory boundary size count |

		MultipartParser class >> on: aStream boundary: aString maxMemory: anInteger [
			<category: 'instance creation'>

			^super new initializeStream: aStream boundary: aString maxMemory: anInteger
		]

		MultipartParser class >> on: aStream boundary: aString [
			<category: 'instance creation'>

			^self on: aStream boundary: aString maxMemory: 1024
		]

		initializeStream: aStream boundary: aString maxMemory: anInteger [
			<category: 'initializing'>

			stream := aStream.
			headersReader := HeadersParser on: aStream.
			maxMemory := anInteger.
			boundary := Character lf asString, '--', aString.
			size := boundary size.
			count := 0.
		]

		nextPart [
			<category: 'parsing'>

			| headers partStream char str |

			stream ifNil: [^nil].
			count = 0 ifTrue: [stream upToAll: boundary].
			(stream next: 2) = '--' ifTrue: [
				stream := nil.
				^nil].

			headers := headersReader nextHeaders.
			partStream := '' writeStream.
			count := count + 1.

			[
				char := stream next.
				(char = Character cr and: [(str := stream next: size) = boundary])
					ifTrue: [
						^Multipart
							boundary: (boundary copyFrom: 4)
							headers: headers
							stream: (partStream flush readStream position: 0)]
					ifFalse: [
						partStream nextPut: char.
						str ifNotNil: [partStream nextPutAll: str]].

				str := nil.
				(partStream isExternalStream not and: [partStream size > maxMemory]) ifTrue: [
					partStream := self convertStreamToFileStream: partStream].
			] repeat.
		]

		convertStreamToFileStream: aStream [
			<category: 'private'>

			| fileStream |

			fileStream := FileStream openTemporaryFile: '/tmp/multipart_'.
			aStream readStream nextPutAllOn: fileStream.
			^fileStream
		]
	]

]
