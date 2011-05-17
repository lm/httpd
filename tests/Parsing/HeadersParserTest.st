Namespace current: Parsing [

	TestCase subclass: HeadersParserTest [
		| readStream expected |

		testNextMethod [
			self assert: (HeadersParser on: 'GET ' readStream) nextMethod = 'GET'.
		]

		testNextUri [
			self assert: (HeadersParser on: '/foo?bar ' readStream) nextUri = '/foo?bar'.
		]

		testVersion [
			readStream :=  '' writeStream nextPutAll: 'HTTP/1.1'; cr; nl;
				readStream.

			self assert: (HeadersParser on: readStream) nextVersion = 'HTTP/1.1'.
		]

		testHeaders [
			readStream := '' writeStream
				nextPutAll: 'Connection: close'; cr; nl;
				nextPutAll: 'Host: example.org'; cr; nl; cr; nl;
				readStream.

			expected := LookupTable from: {
				'Host' -> (Header name: 'Host' value: 'example.org').
				'Connection' -> (Header name: 'Connection' value: 'close').
			}.

			self assert: (HeadersParser on: readStream) nextHeaders = expected.
		]

		testHeadersWithEmptyStream [
			self assert: (HeadersParser on: '' readStream) nextHeaders = LookupTable new.
		]

		testHeadersWithHeaderOnMoreThanOneLine [
			readStream := '' writeStream
				nextPutAll: 'Etag: foo'; cr; nl;
				nextPutAll: ' bar'; cr; nl; cr; nl;
				readStream.

			expected := LookupTable from: {
				'Etag' -> (Header name: 'Etag' value: 'foobar').
			}.

			self assert: (HeadersParser on: readStream) nextHeaders = expected.
		]

		testHeadersOnInvalidStreamContents [
			readStream := '' writeStream
				nextPutAll: 'foo'; cr; nl;
				nextPutAll: 'bar'; cr; nl; cr; nl;
				readStream.

			expected := LookupTable from: {
				'Foo' -> (Header name: 'Foo' value: '').
				'Bar' -> (Header name: 'Bar' value: '').
			}.

			self assert: (HeadersParser on: readStream) nextHeaders = expected.
		]

		testHeadersWithSameNamedHeaders [
			readStream := '' writeStream
				nextPutAll: 'Accept: text/html'; cr; nl;
				nextPutAll: 'Accept: text/plain'; cr; nl; cr; nl;
				readStream.

			expected := LookupTable from: {
				'Accept' -> (Header name: 'Accept' value: 'text/html, text/plain').
			}.

			self assert: (HeadersParser on: readStream) nextHeaders = expected.
		]
	]

]
