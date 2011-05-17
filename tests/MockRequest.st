Object subclass: MockRequest [
	| keepAlive |

	keepAlive: aBool [
		keepAlive := aBool.
	]

	keepAlive [
		^keepAlive ifNil: [false]
	]

	content [
		^'' readStream
	]
]
