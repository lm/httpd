Object subclass: MockResponse [
	| headers stream keepAlive |

	headerAt: aNameString put: aValueString [
		headers ifNil: [headers := Dictionary new].
		headers at: aNameString put: aValueString.
	]

	headers [
		^headers
	]

	headersSent [
		^false
	]

	stream [
		stream ifNil: [stream := WriteStream on: String new].
		^stream
	]

	keepAlive: aBool [
		keepAlive := aBool.
	]

	keepAlive [
		^keepAlive ifNil: [false]
	]

	keepAliveIf: aBool [
		keepAlive := aBool.
	]

	sendHeaders [
	]
]
