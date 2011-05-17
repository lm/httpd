Namespace current: Parsing [

	Object subclass: QueryEncoding [
		| percentEncoding |

		QueryEncoding class >> percentEncoding: aPercentEncoding [
			<category: 'instance creation'>

			^super new initializePercentEncoding: aPercentEncoding
		]

		QueryEncoding class >> new [
			<category: 'instance creation'>

			self shouldNotImplement.
		]

		initializePercentEncoding: aPercentEncoding [
			<category: 'initializing'>

			percentEncoding := aPercentEncoding.
		]

		encode: aDictionary [
			<category: 'encoding'>

			| writeStream first |

			writeStream := WriteStream on: (String new).
			first := true.

			aDictionary keysAndValuesDo: [ :k :v |
				first
					ifTrue: [first := false]
					ifFalse: [writeStream nextPut: $&].

				writeStream
					nextPutAll: (percentEncoding encode: k);
					nextPut: $=;
					nextPutAll: (percentEncoding encode: v).
			].

			^writeStream contents.
		]

		decode: aCollection [
			<category: 'decoding'>

			| query pos key value |

			query := LookupTable new.

			(aCollection subStrings: $&) do: [ :str |
				(pos := str indexOf: $=) = 0
					ifFalse: [
						key := str copyFrom: 1 to: pos - 1.
						value := str copyFrom: pos + 1]
					ifTrue: [
						key := str.
						value := ''].

				query
					at: (percentEncoding decode: key)
					put: (percentEncoding decode: value).
			].

			^query
		]
	]

]
