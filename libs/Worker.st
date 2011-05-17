Object subclass: Worker [
	| queue responder run loop |

	<category: 'Http Processing'>
	<comment: 'I''m working upon one connection, invoke responder on every HTTP request.'>

	Worker class >> process: aQueue with: aResponder [
		<category: 'instance creation'>

		^super new
			initializeQueue: aQueue
			responder: aResponder
	]

	Worker class >> new [
		<category: 'instance creation'>

		self shouldNotImplement.
	]

	initializeQueue: aQueue responder: aResponder [
		<category: 'initializing'>

		queue := aQueue.
		responder := aResponder.
		run := false.
	]

	stop [
		<category: 'control'>

		run := false.
	]

	start [
		<category: 'control'>

		run := true.
		loop := [[self process. run] whileTrue] newProcess.
		loop
			name: 'HTTP worker ', self identityHash printString;
			priority: Processor userBackgroundPriority;
			resume.
	]

	process [
		<category: 'private'>

		queue next sendTo: self.
	]

	process: aConnection keepAliveTimeout: milliseconds [
		<category: 'processing'>

		| response request |

		response := self respondOn: aConnection.

		[
			request := self readRequestFrom: aConnection.
			response keepAliveIf: (milliseconds value > 0 and: [request keepAlive]).
			responder respondTo: request on: response.
			request content setToEnd. "should wait for entire request?"
		]
			on: BadRequest do: [responder respondBadRequestOn: response]
			on: RequestTimeout do: [responder respondRequestTimeoutOn: response].

		response sendHeaders.
		aConnection flush.

		self changed: request -> response.

		(aConnection isPeerAlive and: [response keepAlive])
			ifTrue: [self process: aConnection withTimeout: milliseconds]
			ifFalse: [aConnection close].
	]

	respondOn: aConnection [
		<category: 'processing'>

		^Response respondOn: aConnection
	]

	readRequestFrom: aConnection [
		<category: 'processing'>

		^Request readFrom: aConnection
	]

	process: aConnection withTimeout: milliseconds [
		<category: 'private'>

		[
			(Delay forMilliseconds: milliseconds value)
				value: [
					aConnection ensureReadable.
					queue nextPut: (Smalltalk.Message
						selector: #process:keepAliveTimeout:
						arguments: {aConnection. milliseconds})]
				onTimeoutDo: [
					aConnection close].
		] newProcess name: 'timeouter'; resume.
	]
]
