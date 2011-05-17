Object subclass: Header [
	| name value values valuesParameters |

	<category: 'Http Message'>

	Header class >> name: name value: value [
		<category: 'instance creation'>

		^super new initializeName: name value: value
	]

	Header class >> fromString: aString [
		<category: 'instance creation'>

		^self
			name: (aString copyUpTo: $:)
			value: (aString copyAfter: $:) trimSeparators
	]

	Header class >> new [
		<category: 'instance creation'>

		self shouldNotImplement.
	]

	Header class >> canonicalizeName: aString [
		<category: 'utilities'>

		| readStream writeStream char |

		(aString size = 0) ifTrue: [^aString].

		readStream := aString readStream.
		writeStream := WriteStream on: (String new: aString size).

		readStream peek isLetter ifTrue: [
			writeStream nextPut: readStream next asUppercase].

		[writeStream nextPutAll: (readStream upTo: $-) asLowercase.
		readStream atEnd] whileFalse: [
			writeStream nextPut: $-.
			(readStream peek ~= $- and: [(char := readStream next) notNil])
				ifTrue: [writeStream nextPut: char asUppercase].
		].

		aString last = $- ifTrue: [writeStream nextPut: $-].

		^writeStream contents
	]

	initializeName: aNameString value: aValueString [
		<category: 'initializing'>

		| str |

		str := aValueString asString.
		((str includes: Character nl) or: [str includes: Character cr]) ifTrue: [
			^self error: 'Header value cannot contain new line character'].

		name := self class canonicalizeName: aNameString.
		value := str.
	]

	initializeValues [
		<category: 'initializing'>

		| parts params pos str |

		values ifNotNil: [^self].

		valuesParameters := OrderedCollection new.
		values := (value subStrings: $,) collect: [ :value |
			parts := value subStrings: $;.
			params := valuesParameters add: LookupTable new.

			(parts copyFrom: 2) do: [ :part |
				pos := part indexOf: $=.
				str := part copyFrom: pos + 1.

				((str startsWith: '"') and: [str endsWith: '"']) ifTrue: [
					str := str copyFrom: 2 to: str size - 1].

				params
					at: (part copyFrom: 1 to: pos - 1) trimSeparators
					put: str.
			].

			parts first trimSeparators.
		].
	]

	= aHeader [
		<category: 'testing'>

		^self class = aHeader class
			and: [aHeader name = name
			and: [aHeader value = value]]
	]

	+ aHeader [
		<category: 'arithmetic'>

		^self class name: name value: value, ', ', aHeader value
	]

	hash [
		<category: 'testing'>

		^name hash bitXor: value hash
	]

	name [
		<category: 'accessing'>

		^name
	]

	value [
		<category: 'accessing'>

		^value
	]

	values [
		<category: 'accessing'>

		self initializeValues.
		^values copy
	]

	parametersAt: anIndex [
		<category: 'accessing'>

		self initializeValues.
		^valuesParameters at: anIndex
	]

	withValue: aString [
		<category: 'copying'>

		^self class name: name value: value, aString
	]

	printOn: aStream [
		<category: 'printing'>

		aStream nextPut: $';
			nextPutAll: name;
			nextPutAll: ': ';
			nextPutAll: value;
			nextPut: $'.
	]
]
