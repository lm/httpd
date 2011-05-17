Object subclass: Message [

	<category: 'Http Message'>

	headers [
		<category: 'accessing'>

		self subclassResposibility.
	]

	headerAt: aString [
		<category: 'accessing'>

		^self headerAt: aString ifAbsent: [].
	]

	headerAt: aString ifAbsent: aBlock [
		<category: 'accessing'>

		^self headers at: aString ifAbsent: [Header name: aString value: aBlock value]
	]

	headerAt: aString ifPresent: aBlock [
		<category: 'accessing'>

		^self headers at: aString ifPresent: aBlock
	]

	keepAlive [
		<category: 'testing'>

		self headers at: 'Connection' ifPresent: [ :header |
			^header value asLowercase = 'keep-alive'].

		^false
	]
]
