Stream subclass: LimitedStream [
	| stream limit position |

	<category: 'Streams-Files'>
	<comment: 'I provide a view of a part of a substream.'>

	LimitedStream class >> on: aStream limit: anInteger [
		<category: 'instance creation'>

		^self new
			stream: aStream;
			limit: anInteger;
			initialize
	]

	initialize [
		<category: 'initializing'>

		position := 0.
	]

	atEnd [
		<category: 'stream operations'>

		^position >= limit or: [stream atEnd]
	]

	nextAvailable: n into: aCollection startingAt: pos [
		<category: 'stream operations'>

		| number |

		number := stream
			nextAvailable: (n min: limit - position)
			into: aCollection
			startingAt: pos.
		position := position + number.
		^number
	]

	next [
		<category: 'stream operations'>

		self atEnd ifTrue: [^nil].
		^stream next ifNotNil: [ :v | position := position + 1. v]
	]

	peek [
		<category: 'stream operations'>

		self atEnd ifTrue: [^nil].
		^stream peek
	]

	peekFor: aCharacter [
		<category: 'stream operations'>

		self atEnd ifTrue: [^nil].
		^stream peekFor: aCharacter
	]

	size [
		<category: 'stream operations'>

		^stream size
	]

	skip: anInteger [
		<category: 'stream operations'>

		stream skip: anInteger
	]

	setToEnd [
		<category: 'positioning'>

		self skip: limit - position.
		position := limit.
	]

	printOn: aStream [
		<category: 'printing'>

		aStream
			print: stream;
			nextPut: $[;
			print: limit;
			nextPut: $]
	]

	file [
		<category: 'accessing'>

		^stream file
	]

	name [
		<category: 'accessing'>

		^stream name
	]

	species [
		<category: 'accessing'>

		^stream species
	]

	stream: aStream [
		<category: 'accessing'>

		stream := aStream
	]

	limit: anInteger [
		<category: 'accessing'>

		limit := anInteger
	]

	flush [
		<category: 'stream protocol'>

		stream flush
	]

	close [
		<category: 'stream protocol'>

		stream close
	]
]
