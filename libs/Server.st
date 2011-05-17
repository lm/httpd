Object subclass: Server [
	| responder port socket loop workers queue connections keepAliveTimeout |

	<category: 'Http Processing'>
	<comment: 'Everything starts here, I handle connection queue and spawn workers.'>

	Server class >> responder: aResponder port: aPort [
		<category: 'instance creation'>

		^super new initializeResponder: aResponder port: aPort
	]

	Server class >> new [
		<category: 'instance creation'>

		self shouldNotImplement.
	]

	initializeResponder: aResponder port: aPort [
		<category: 'initializing'>

		responder := aResponder.
		port := aPort.
		workers := Set new.
		queue := SharedQueue new.
		connections := WeakIdentitySet new.
	]

	responder [
		<category: 'accessing'>

		^responder
	]

	port [
		<category: 'accessing'>

		^port
	]

	isServing [
		<category: 'accessing'>

		^loop notNil
	]

	serve [
		<category: 'control'>

		10 timesRepeat: [workers add: self spawnWorker start].
		socket := Sockets.ServerSocket port: port queueSize: 50.
		keepAliveTimeout := ValueHolder with: 20000.

		loop := [
			[
				self accept.
				socket isOpen.
			] whileTrue: [Processor yield].
		] newProcess.

		loop name: 'HTTP server loop';
			resume.
	]

	stop [
		<category: 'control'>

		socket close.
		socket := nil.
		workers size timesRepeat: [self addWorkerTask: #stop arguments: {}].
		loop := nil.
	]

	accept [
		<category: 'private'>

		socket waitForConnection.
		socket accept ifNotNil: [ :connection |
			connections add: connection.
			keepAliveTimeout value: (connections size >= 20 ifTrue: [0] ifFalse: [20000]).
			self addWorkerTask: #process:keepAliveTimeout: arguments: {connection. keepAliveTimeout}].
	]

	addWorkerTask: aSymbol arguments: anArray [
		<category: 'private'>

		queue nextPut: (Smalltalk.Message selector: aSymbol arguments: anArray).
	]

	spawnWorker [
		<category: 'private'>

		^(Worker process: queue with: responder)
			addDependent: self;
			yourself
	]

	update: aParameter [
		<category: 'change and update'>

		self changed: aParameter.
	]
]
