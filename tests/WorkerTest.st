TestCase subclass: WorkerTest [
	| responder queue worker connection timeout |

	setUp [
		responder := MockResponder new.
		queue := SharedQueue new.
		worker := MockWorker process: queue with: responder.

		worker request: MockRequest new.
		worker response: MockResponse new.
		queue nextPut: (Smalltalk.Message
			selector: #process:keepAliveTimeout:
			arguments: {connection := MockConnection new. timeout := 20 asValue}).
		queue nextPut: (Smalltalk.Message selector: #stop arguments: {}).
	]

	testInvokesResponder [
		worker start.
		Processor yield.
		self assert: responder responded.
	]

	testInvokesResponderOnBadRequest [
		worker readRequestBlock: [BadRequest signal].
		worker start.
		Processor yield.
		self assert: responder respondedBadRequest.
	]

	testInvokesResponderOnRequestTimeout [
		worker readRequestBlock: [RequestTimeout signal].
		worker start.
		Processor yield.
		self assert: responder respondedRequestTimeout.
	]

	testPutAlivedConnectionBackToQueue [
		| initialRequest |

		initialRequest := queue peek.

		worker request keepAlive: true.
		worker start.
		Processor yield.
		self assert: (queue isEmpty not and: [initialRequest ~~ queue peek]).
	]

	testCloseConnectionForZeroTimeout [
		| semaphore closed |

		semaphore := Semaphore new.
		closed := false.

		connection closeBlock: [
			closed := true.
			semaphore signal].
		timeout value: 0.

		worker request keepAlive: true.
		worker start.

		(Delay forMilliseconds: 5) timedWaitOn: semaphore.
		self assert: closed.
	]

	testCloseAlivedConnectionWhenTimeout [
		| semaphore closed |

		semaphore := Semaphore new.
		closed := false.

		connection ensureReadableBlock: [(Delay forMilliseconds: 10) wait].
		connection closeBlock: [
			closed := true.
			semaphore signal].
		timeout value: 5.

		worker request keepAlive: true.
		worker start.

		(Delay forMilliseconds: 15) timedWaitOn: semaphore.
		self assert: closed.

	]
]
