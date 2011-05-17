WriteStream subclass: ChunkedWriter [
	| response chunkSize |

	<category: 'Http Message'>
	<comment: 'I write to stream in chunk, as described in RFC 2616.'>

	ChunkedWriter class >> writeTo: aResponse [
		<category: 'instance creation'>

		^(super on: String new) initializeResponse: aResponse
	]

	ChunkedWriter class >> on: aCollection [
		<category: 'instance creation'>

		self shouldNotImplement.
	]

	initializeResponse: aResponse [
		<category: 'initializing'>

		response := aResponse.
		chunkSize := 4096.
	]

	chunkSize: anInteger [
		<category: 'accessing'>

		chunkSize := anInteger.
	]

	chunkSize [
		<category: 'accessing'>

		^chunkSize
	]

	nextPut: anObject [
		<category: 'accessing-writing'>

		super nextPut: anObject.
		self size >= chunkSize ifTrue: [self flush].
	]

	next: n putAll: aCollection startingAt: pos [
		<category: 'accessing-writing'>

		super next: n putAll: aCollection startingAt: pos.
		self size >= chunkSize ifTrue: [self flush].
	]

	flush [
		<category: 'buffering'>

		| stream |

		response headersSent ifFalse: [response headerAt: 'Transfer-Encoding' put: 'chunked'].
		self isEmpty ifTrue: [^self].

		stream := response stream.

		self size printOn: stream base: 16.
		stream cr; nl.
		self readStream nextAvailablePutAllOn: stream.
		stream cr; nl; flush.
		self emptyStream.
	]

	flushEnd [
		<category: 'buffering'>

		self flush.
		response stream
			nextPut: $0;
			cr; nl;
			cr; nl;
			flush.
	]
]
