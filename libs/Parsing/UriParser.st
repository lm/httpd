Namespace current: Parsing [

	Object subclass: UriParser [
		| stream lastDelimeter |

		<category: 'Uri'>

		UriParser class >> on: aStream [
			<category: 'instance creation'>

			^super new initializeStream: aStream
		]

		UriParser class >> new [
			<category: 'instance creation'>

			self shouldNotImplement.
		]

		initializeStream: aStream [
			<category: 'initializing'>

			stream := aStream.
		]

		nextScheme [
			<category: 'parsing'>

			^stream upToAll: '://'.
		]

		nextAuthority [
			<category: 'parsing'>

			^self nextComponent: '/?#'
		]

		nextPath [
			<category: 'parsing'>

			^self nextComponent: '?#'
		]

		nextQuery [
			<category: 'parsing'>

			^self nextComponent: '#'
		]

		nextFragment [
			<category: 'parsing'>

			^stream upToEnd
		]

		nextComponent: delimeters [
			<category: 'parsing'>

			| writeStream char |

			(delimeters includes: lastDelimeter) ifTrue: [^''].
			writeStream := WriteStream on: ''.

			[(char := stream next) isNil or: [delimeters includes: char]] whileFalse: [
				writeStream nextPut: char].

			lastDelimeter := char.
			^writeStream contents
		]
	]

]
