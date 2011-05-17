Object subclass: Logger [
	| stream queue loop |

	Logger class >> logOn: aStream [
		<category: 'instance creation'>

		^super new initializeStream: aStream
	]

	Logger class >> new [
		<category: 'instance creation'>

		self shouldNotImplement.
	]

	initializeStream: aStream [
		<category: 'initializing'>

		stream := aStream.
		queue := SharedQueue new.
		loop := [[self logEvent. queue isNil] whileFalse] newProcess.
		loop
			name: 'Logger loop';
			priority: Processor userBackgroundPriority;
			resume.
	]

	logEvent [
		<category: 'private'>

		stream nextPutAll: queue next.
	]

	update: aParameter [
		<category: 'change and update'>

		queue nextPut: (self logRequest: aParameter key response: aParameter value).
	]

	logRequest: aRequest response: aResponse [
		<category: 'formating'>

		^(WriteStream on: (String new: 100))
			display: DateTime now;
			space;
			nextPutAll: aRequest method;
			space;
			display: aRequest uri;
			space;
			display: aRequest remoteAddress;
			nextPutAll: ' -> ';
			display: aResponse code;
			nl;
			contents.
	]
]
