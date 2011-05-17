Object subclass: Uri [
	| percentEncoding queryEncoding scheme authority path query fragment |

	<category: 'Uri'>
	<comment: 'I''m a Uniform Resource Identifier (URI) as described in RFC 3986'>

	Uri class >> new [
		<category: 'instance creation'>

		| percentEncoding |

		percentEncoding := Parsing.PercentEncoding new.

		^self
			withPercentEncoding: percentEncoding
			queryEncoding: (Parsing.QueryEncoding percentEncoding: percentEncoding copy enablePlusSignDecoding)
	]

	Uri class >> fromString: aString [
		<category: 'instance creation'>

		^self new uri: aString.
	]

	Uri class >> withPercentEncoding: aPercentEncoding queryEncoding: aQueryEncoding [
		<category: 'instance creation'>

		^super new
			initializePercentEncoding: aPercentEncoding
			queryEncoding: aQueryEncoding
	]

	Uri class >> defaultPorts [
		<category: 'accessing'>

		^LookupTable from: {
			#ftp -> 21.
			#ssh -> 22.
			#smtp -> 25.
			#time -> 37.
			#http -> 80.
			#https -> 443.
			#pop3 -> 110.
			#nntp -> 119.
		}
	]

	Uri class >> webalize: aString [
		<category: 'utilities'>
		"Replace all non alphanumeric characters with dash and translate them to ASCII"

		| writeStream prevChar |

		writeStream := WriteStream on: (String new: aString size).

		(aString asString: 'ASCII//TRANSLIT') do: [ :char |
			prevChar := char isAlphaNumeric
				ifTrue: [writeStream nextPut: char]
				ifFalse: [prevChar = $- ifFalse: [writeStream nextPut: $-]. $-].
		].

		^writeStream contents
	]

	initializePercentEncoding: aPercentEncoding queryEncoding: aQueryEncoding [
		<category: 'initializing'>

		percentEncoding := aPercentEncoding.
		queryEncoding := aQueryEncoding.
	]

	uri: aString [
		<category: 'accessing'>

		| parser |

		parser := Parsing.UriParser on: aString readStream.
		scheme := parser nextScheme.
		self authorityFromString: parser nextAuthority.
		path := percentEncoding decode: parser nextPath.
		self queryFromString: parser nextQuery.
		fragment := percentEncoding decode: parser nextFragment.
	]

	= anUri [
		<category: 'testing'>

		^self class = anUri class
			and: [scheme = anUri scheme
			and: [authority = anUri authority
			and: [path = anUri path
			and: [query = anUri query
			and: [fragment = anUri fragment]]]]]
	]

	hash [
		<category: 'testing'>

		^(((scheme hash
			bitXor: authority hash)
			bitXor: path hash)
			bitXor: query hash)
			bitXor: fragment hash
	]

	scheme: aString [
		<category: 'accessing'>

		scheme := aString.
	]

	scheme [
		<category: 'accessing'>

		^scheme
	]

	authority: aAuthority [
		<category: 'accessing'>

		aAuthority port ifNil: [
			self class defaultPorts
				at: scheme asSymbol
				ifPresent: [ :v | aAuthority port: v]].
		authority := aAuthority.
	]

	authorityFromString: aString [
		<category: 'accessing'>

		self authority: (UriAuthority fromString: aString).
	]

	authority [
		<category: 'accessing'>

		^authority
	]

	path: aString [
		<category: 'accessing'>

		path := aString.
	]

	path [
		<category: 'accessing'>

		^path
	]

	query: aDictionary [
		<category: 'accessing'>

		query := aDictionary.
	]

	queryFromString: aString [
		<category: 'accessing'>

		query := queryEncoding decode: aString.
	]

	query [
		<category: 'accessing'>

		^query copy
	]

	queryAsString [
		<category: 'accessing'>

		^queryEncoding encode: query
	]

	fragment: aString [
		<category: 'accessing'>

		fragment := aString.
	]

	fragment [
		<category: 'accessing'>

		^fragment
	]

	baseUri [
		<category: 'accessing'>

		^self copy
			path: '';
			query: self query copyEmpty;
			fragment: '';
			yourself

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

		aStream
			nextPutAll: scheme;
			nextPutAll: '://';
			print: authority;
			nextPut: $/;
			nextPutAll: (percentEncoding encode: path skip: '-._~/').

		query size = 0 ifFalse: [
			aStream
				nextPut: $?;
				nextPutAll: self queryAsString].

		fragment isEmpty ifFalse: [
			aStream
				nextPut: $#;
				nextPutAll: self fragment].
	]
]
