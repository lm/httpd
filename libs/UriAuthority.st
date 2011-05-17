Object subclass: UriAuthority [
	| percentEncoding user password host port |

	<category: 'Uri'>
	<comment: 'I''m URI authority component'>

	UriAuthority class >> new [
		<category: 'instance creation'>

		^super new initialize
	]

	UriAuthority class >> fromString: aString [
		<category: 'instance creation'>

		^self new fromString: aString
	]

	initialize [
		<category: 'initializing'>

		percentEncoding := Parsing.PercentEncoding new.
	]

	fromString: aString [
		<category: 'converting'>

		| pos str |

		str := aString.

		(pos := str indexOf: $@) = 0 ifFalse: [
			self userInfo: (str copyFrom: 1 to: pos - 1).
			str := str copyFrom: pos + 1].

		(pos := str indexOf: $:) = 0
			ifTrue: [
				host := percentEncoding decode: str]
			ifFalse: [
				host := percentEncoding decode: (str copyFrom: 1 to: pos - 1).
				port := (str copyFrom: pos + 1) asNumber]
	]

	userInfo: aString [
		<category: 'accessing'>

		| pos |

		(pos := aString indexOf: $:) = 0
			ifTrue: [
				user := percentEncoding decode: aString]
			ifFalse: [
				user := percentEncoding decode: (aString copyFrom: 1 to: pos - 1).
				password := percentEncoding decode: (aString copyFrom: pos + 1)].
	]

	= anUriAuthority [
		<category: 'testing'>

		^self class = anUriAuthority class
			and: [anUriAuthority user = user
			and: [anUriAuthority password = password
			and: [anUriAuthority host = host
			and: [anUriAuthority port = port]]]]
	]

	hash [
		<category: 'testing'>

		^((user hash bitXor: password hash) bitXor: host hash) bitXor: port hash
	]

	user: aString [
		<category: 'accessing'>

		user := aString.
	]

	user [
		<category: 'accessing'>

		^user
	]

	password: aString [
		<category: 'accessing'>

		password := aString.
	]

	password [
		<category: 'accessing'>

		^password
	]

	host: aString [
		<category: 'accessing'>

		host := aString.
	]

	host [
		<category: 'accessing'>

		^host
	]

	port: anInteger [
		<category: 'accessing'>

		port := anInteger.
	]

	port [
		<category: 'accessing'>

		^port
	]

	asString [
		<category: 'converting'>

		| stream |

		stream := WriteStream on: (String new: 30).
		self printOn: stream.
		^stream contents
	]

	printOn: aStream [
		<category: 'printing'>

		user ifNotNil: [
			aStream nextPutAll: (percentEncoding encode: user).

			password ifNotNil: [
				aStream
					nextPut: $:;
					nextPutAll: (percentEncoding encode: password)].

			aStream nextPut: $@].

		aStream nextPutAll: (percentEncoding encode: host).

		(port isNil or: [Uri defaultPorts includes: port]) ifFalse: [
			aStream
				nextPut: $:;
				nextPutAll: port printString].
	]
]
