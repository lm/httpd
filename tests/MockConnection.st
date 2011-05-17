Object subclass: MockConnection [
	| flushed open ensureReadableBlock closeBlock |

	MockConnection class >> new [
		^super new initialize
	]

	initialize [
		flushed := 0.
		open := true.
	]

	flush [
		flushed := true.
	]

	isFlushed [
		^flushed notNil
	]

	closeBlock: aBlock [
		closeBlock := aBlock.
	]

	close [
		closeBlock ifNotNil: [ :b | b value].
		open := false.
	]

	isPeerAlive [
		^open
	]

	ensureReadableBlock: aBlock [
		ensureReadableBlock := aBlock.
	]

	ensureReadable [
		ensureReadableBlock ifNotNil: [ :b | b value].
	]

	atEnd [
		^open not
	]
]
