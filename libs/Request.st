Message subclass: Request [
	| stream reader method rawUri uri version headers content formData |

	<category: 'Http Message'>

	Request class >> readFrom: aStream [
		<category: 'instance creation'>

		^self readFrom: aStream with: (Parsing.HeadersParser on: aStream)
	]

	Request class >> readFrom: aStream with: aReader [
		<category: 'instance creation'>

		^super new initializeStream: aStream reader: aReader
	]

	Request class >> new [
		<category: 'instance creation'>

		self shouldNotImplement.
	]

	initializeStream: aStream reader: aReader [
		<category: 'initializing'>

		stream := aStream.
		reader := aReader.

		(Delay forSeconds: 20)
			value: [
				method := self validateOneLineString: reader nextMethod.
				rawUri := self validateOneLineString: reader nextUri.
				version := reader nextVersion.
				headers := reader nextHeaders.

				uri := Uri fromString: (
					(rawUri startsWith: 'http://')
						ifTrue: [
							rawUri]
						ifFalse: [
							| host |
							host := headers at: 'Host' ifAbsent: [BadRequest signal].
							'http://', host value, rawUri]).
			]
			onTimeoutDo: [RequestTimeout signal]
	]

	validateOneLineString: aString [
		<category: 'private'>

		(aString includesAnyOf: {Character cr. Character nl}) ifTrue: [BadRequest signal].
		^aString
	]

	method [
		<category: 'accessing'>

		^method
	]

	rawUri [
		<category: 'accessing'>

		^rawUri
	]

	uri [
		<category: 'accessing'>

		^uri
	]

	version [
		<category: 'accessing'>

		^version
	]

	headers [
		<category: 'accessing'>

		^headers
	]

	remoteAddress [
		<category: 'accessing'>

		^stream remoteAddress
	]

	isAlive [
		<category: 'testing'>

		stream canRead ifTrue: [stream peek].
		^stream isPeerAlive
	]

	content [
		<category: 'accessing'>

		^content ifNil: [
			content := LimitedStream
				on: stream
				limit: self contentSize]
	]

	contentSize [
		<category: 'accessing'>

		^(self headerAt: 'Content-Length' ifAbsent: [0]) value asNumber
	]

	formData [
		<category: 'accessing'>

		formData ifNil: [formData := self processFormData].
		^formData copy
	]

	processFormData [
		<category: 'private'>

		| contentType |

		self hasFormData
			ifFalse: [^self error: 'Cannot get form data request is not application/x-www-form-urlencoded'].

		contentType := self headerAt: 'Content-Type'.
		^contentType values first asLowercase = 'multipart/form-data'
			ifTrue: [self processMultipartFormData]
			ifFalse: [self processUrlEncodedForm]
	]

	processMultipartFormData [
		<category: 'private'>

		| formData reader part header params |

		formData := LookupTable new: 4.
		reader := self createMultipartParser.

		[(part := reader nextPart) notNil] whileTrue: [
			header := part headers at: 'Content-Disposition'.
			params := header parametersAt: 1.

			header values first asLowercase = 'form-data' ifTrue: [
				formData
					at: (params at: 'name')
					put: ((params includesKey: 'filename')
						ifTrue: [part]
						ifFalse: [part stream contents])]].

		^formData
	]

	createMultipartParser [
		<category: 'private'>

		^Parsing.MultipartParser
			on: self content
			boundary: (((self headerAt: 'Content-Type') parametersAt: 1) at: 'boundary').
	]

	processUrlEncodedForm [
		<category: 'private'>

		^(Parsing.QueryEncoding percentEncoding: (Parsing.PercentEncoding new enablePlusSignDecoding)) decode: self content contents
	]

	hasFormData [
		<category: 'testing'>

		| contentType |
		contentType := (self headerAt: 'Content-Type' ifAbsent: [^false]) values first asLowercase.
		^contentType = 'application/x-www-form-urlencoded' or: [contentType = 'multipart/form-data']
	]
]
