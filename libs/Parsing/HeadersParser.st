Namespace current: Parsing [

	Object subclass: HeadersParser [
		| stream |

		<category: 'Http Message'>

		HeadersParser class >> on: aStream [
			<category: 'instance creation'>

			^super new initializeStream: aStream
		]

		HeadersParser class >> new [
			<category: 'instance creation'>

			self shouldNotImplement.
		]

		initializeStream: aStream [
			<category: 'initializing'>

			stream := aStream.
		]

		nextMethod [
			<category: 'parsing'>

			^stream upTo: Character space
		]

		nextUri [
			<category: 'parsing'>

			^stream upTo: Character space
		]

		nextVersion [
			<category: 'parsing'>

			^stream upToAll: (String with: Character cr with: Character nl)
		]

		nextHeaders [
			<category: 'parsing'>

			| headers line header |

			headers := LookupTable new.

			[line := stream upToAll: (String with: Character cr with: Character nl).
			line = ''] whileFalse: [
				(header isNil not and: [line first = Character space or: [line first = Character tab]])
					ifTrue: [
						headers at: header name put: (header withValue: line trimSeparators)]
					ifFalse: [
						header := Header fromString: line.
						headers at: header name ifPresent: [ :v | header := v + header].
						headers at: header name put: header].
			].

			^headers
		]
	]

]
