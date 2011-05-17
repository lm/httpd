Namespace current: Parsing [

	Object subclass: PercentEncoding [
		| decodePlusSign |

		PercentEncoding class >> new [
			<category: 'instance creation'>

			^super new initialize
		]

		initialize [
			<category: 'initializing'>

			decodePlusSign := false.
		]

		enablePlusSignDecoding [
			<category: 'accessing'>

			decodePlusSign := true.
		]

		encode: aCollection [
			<category: 'encoding'>

			^self encode: aCollection skip: '-._~'.
		]

		encode: aCollection skip: skipCollection [
			<category: 'encoding'>

			| readStream writeStream char |

			readStream := aCollection readStream.
			writeStream := WriteStream on: (String new: aCollection size).

			[readStream atEnd] whileFalse: [
				char := readStream next.
				(char isAlphaNumeric or: [skipCollection includes: char])
					ifFalse: [
						writeStream nextPut: $%.
						char value printOn: writeStream paddedWith: $0 to: 2 base: 16]
					ifTrue: [
						writeStream nextPut: char].
			].
			^writeStream contents
		]

		decode: aCollection [
			<category: 'decoding'>

			^self decode: aCollection skip: ''.
		]

		decode: aCollection skip: skipCollection [
			<category: 'decoding'>

			| readStream writeStream char char2 |

			readStream := aCollection readStream.
			writeStream := WriteStream on: (String new: aCollection size).

			[readStream atEnd] whileFalse: [
				char := readStream next.
				(char = $% and: [readStream atEnd not and: [readStream peek isDigit: 16]])
					ifFalse: [
						writeStream nextPut: ((decodePlusSign and: [char = $+])
							ifTrue: [Character space]
							ifFalse: [char])]
					ifTrue: [
						char := readStream next.
						(readStream atEnd not and: [readStream peek isDigit: 16])
							ifFalse: [
								writeStream nextPut: $%; nextPut: char]
							ifTrue: [
								char2 := Character value: (char asUppercase digitValue * 16 + readStream peek asUppercase digitValue).
								(skipCollection includes: char2)
									ifTrue: [
										writeStream
											nextPut: $%;
											nextPut: char;
											nextPut: readStream next]
									ifFalse: [
										writeStream nextPut: char2.
										readStream next]]].
			].

			^writeStream contents
		]
	]

]
