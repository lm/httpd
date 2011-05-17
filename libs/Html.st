Object subclass: Html [
	Html class >> escape: aCollection [
		| writeStream readStream |

		writeStream := WriteStream on: (String new: aCollection size).
		readStream := aCollection readStream.

		[readStream atEnd] whileFalse: [
			writeStream nextPutAll: (self escapeCharacter: readStream next)].

		^writeStream contents
	]

	Html class >> escapeCharacter: aCharacter [
		aCharacter = $& ifTrue: [^'&amp;'].
		aCharacter = $< ifTrue: [^'&lt;'].
		aCharacter = $> ifTrue: [^'&gt;'].
		aCharacter = $<34> ifTrue: [^'&quot;'].
		aCharacter = $<39> ifTrue: [^'&#039;'].
		^aCharacter asString
	]


	Html class >> escapeSkipApostrophe: aCollection [
		| writeStream readStream |

		writeStream := WriteStream on: (String new: aCollection size).
		readStream := aCollection readStream.

		[readStream atEnd] whileFalse: [
			writeStream nextPutAll: (self escapeCharacterSkipApostrophe: readStream next)].

		^writeStream contents
	]

	Html class >> escapeCharacterSkipApostrophe: aCharacter [
		aCharacter = $& ifTrue: [^'&amp;'].
		aCharacter = $< ifTrue: [^'&lt;'].
		aCharacter = $> ifTrue: [^'&gt;'].
		aCharacter = $<34> ifTrue: [^'&quot;'].
		^aCharacter asString
	]

	Html class >> escapeSkipQuotes: aCollection [
		| writeStream readStream |

		writeStream := WriteStream on: (String new: aCollection size).
		readStream := aCollection readStream.

		[readStream atEnd] whileFalse: [
			writeStream nextPutAll: (self escapeCharacterSkipQuotes: readStream next)].

		^writeStream contents
	]

	Html class >> escapeCharacterSkipQuotes: aCharacter [
		aCharacter = $& ifTrue: [^'&amp;'].
		aCharacter = $< ifTrue: [^'&lt;'].
		aCharacter = $> ifTrue: [^'&gt;'].
		^aCharacter asString
	]

	Html class >> escapeComment: aCollection [
		| writeStream readStream char |

		writeStream := WriteStream on: (String new: aCollection size).
		readStream := aCollection readStream.

		[readStream atEnd] whileFalse: [
			writeStream nextPut: (char := readStream next).
			(char = $- and: [readStream peek = $-]) ifTrue: [
				readStream next.
				writeStream nextPutAll: '-><!-- ']].

		^writeStream contents
	]
]
