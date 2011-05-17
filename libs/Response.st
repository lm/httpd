Message subclass: Response [
	| stream writer code headers headersSent |

	<category: 'Http Message'>
	<comment: 'I take care about all response headers as a response body.'>

	Codes := Dictionary from: {
		100 -> 'Continue'.
		101 -> 'Switching Protocols'.
		200 -> 'OK'.
		201 -> 'Created'.
		202 -> 'Accepted'.
		203 -> 'Not-Authoritative Information'.
		204 -> 'No Content'.
		205 -> 'Reset Content'.
		206 -> 'Partial Content'.
		300 -> 'Multiple Choices'.
		301 -> 'Moved Permanently'.
		302 -> 'Found'.
		303 -> 'See Other'.
		304 -> 'Not Modified'.
		305 -> 'Use Proxy'.
		307 -> 'Temporary Redirect'.
		400 -> 'Bad Request'.
		401 -> 'Unauthorized'.
		403 -> 'Forbidden'.
		404 -> 'Not Found'.
		405 -> 'Method Not Allowed'.
		406 -> 'Not Acceptable'.
		407 -> 'Proxy Authentication Required'.
		408 -> 'Request Timeout'.
		409 -> 'Conflict'.
		410 -> 'Gone'.
		411 -> 'Length Required'.
		412 -> 'Precondition Failed'.
		413 -> 'Request Entity Too Large'.
		414 -> 'Request-URI Too Long'.
		415 -> 'Unsupported Media Type'.
		416 -> 'Requested Range Not Satisfiable'.
		417 -> 'Expectation Failed'.
		500 -> 'Internal Server Error'.
		501 -> 'Not Implemented'.
		502 -> 'Bad Gateway'.
		503 -> 'Service Unavailable'.
		504 -> 'Gateway Timeout'.
		505 -> 'HTTP Version Not Supported'.
	}.

	Response class >> respondOn: aStream [
		<category: 'instance creation'>

		^super new initializeStream: aStream
	]

	Response class >> new [
		<category: 'instance creation'>

		self shouldNotImplement.
	]

	Response class >> reasonFor: aCode [
		<category: 'codes'>

		^Codes at: aCode
	]

	initializeStream: aStream [
		<category: 'initializing'>

		stream := aStream.
		code := 200.
		headers := LookupTable new: 5.
		headersSent := false.

		self headerAt: 'Connection' put: 'close'.
	]

	code: aInteger [
		<category: 'accessing'>

		headersSent ifTrue: [self error: 'Cannot set response code, headers already sent'].
		code := aInteger.
	]

	code [
		<category: 'accessing'>

		^code
	]

	stream [
		<category: 'accessing'>

		headersSent ifFalse: [self sendHeaders].
		^stream
	]

	writer [
		<category: 'accessing'>

		^writer ifNil: [writer := ChunkedWriter writeTo: self]
	]

	nextPutGarbageOn: aStream [
		<category: 'utility'>

		| chars |

		chars := {Character tab. Character cr. Character nl}.
		2000 timesRepeat: [aStream nextPut: chars atRandom].
	]

	headerAt: aNameString put: aValueString [
		<category: 'accessing'>

		^self headerAt: aNameString put: aValueString
			ifHeadersSent: [self error: 'Cannot set header, headers already sent']
	]

	headerAt: aNameString put: aValueString ifHeadersSent: aBlock [
		<category: 'accessing'>

		^headersSent
			ifTrue: [aBlock value]
			ifFalse: [headers at: aNameString put: (Header name: aNameString value: aValueString)]
	]

	headers [
		<category: 'accessing'>

		^headers copy
	]

	headersSent [
		<category: 'testing'>

		^headersSent
	]

	sendHeaders [
		<category: 'private'>

		headersSent ifTrue: [^self].

		stream
			nextPutAll: 'HTTP/1.1 ';
			print: code;
			space;
			nextPutAll: (self class reasonFor: code);
			cr;
			nl.

		headers do: [ :header |
			stream
				nextPutAll: header name;
				nextPut: $:;
				space;
				nextPutAll: header value;
				cr;
				nl].

		stream cr; nl.
		headersSent := true.
	]

	keepAliveIf: aBool [
		<category: 'accessing'>

		aBool ifTrue: [self headerAt: 'Connection' put: 'keep-alive'].
	]
]
