Namespace current: Parsing [

	Object subclass: Multipart [
		| boundary headers stream |

		Multipart class >> boundary: boundary headers: headers stream: stream [
			<category: 'instance creation'>

			^super new initializeBoundary: boundary headers: headers stream: stream
		]

		Multipart class >> new [
			<category: 'instance creation'>

			self shouldNotImplement.
		]

		initializeBoundary: aBoundary headers: aHeaders stream: aStream [
			<category: 'initializing'>

			boundary := aBoundary.
			headers := aHeaders.
			stream := aStream.
		]

		= aMultipart [
			<category: 'testing'>

			^self class = aMultipart class
				and: [boundary = aMultipart boundary
				and: [headers = aMultipart headers
				and: [stream = aMultipart stream]]]
		]

		hash [
			<category: 'testing'>

			^(boundary hash bitXor: headers hash) bitXor: stream hash
		]

		boundary [
			<category: 'accessing'>

			^boundary
		]

		headers [
			<category: 'accessing'>

			^headers
		]

		stream [
			<category: 'accessing'>

			^stream
		]

		printOn: aStream [
			<category: 'printing'>

			super printOn: aStream.
			aStream
				space;
				display: boundary.
		]
	]

]
