Namespace current: Parsing [

	TestCase subclass: MultipartParserTest [
		| writeStream reader part |

		testNextPart [
			writeStream := '' writeStream.
			writeStream cr; nl;
				nextPutAll: '--foo'; cr; nl;
				nextPutAll: 'Content-Type: text/html'; cr; nl;
				cr; nl;
				nextPutAll: 'bar';
				cr; nl;
				nextPutAll: '--foo--'.

			reader := MultipartParser on: writeStream readStream boundary: 'foo'.
			part := reader nextPart.

			self
				assert: part boundary = 'foo';
				assert: part headers = (LookupTable from: {'Content-Type' -> (Header name: 'Content-Type' value: 'text/html')});
				assert: part stream contents = 'bar';
				assert: nil = reader nextPart.
		]

		testNextPartWithEmptyPart [
			writeStream := '' writeStream.
			writeStream cr; nl;
				nextPutAll: '--foo'; cr; nl;
				nextPutAll: 'Content-Type: text/html'; cr; nl;
				cr; nl;
				cr; nl;
				nextPutAll: '--foo--'.

			part := (MultipartParser on: writeStream readStream boundary: 'foo') nextPart.

			self
				assert: part boundary = 'foo';
				assert: part headers = (LookupTable from: {'Content-Type' -> (Header name: 'Content-Type' value: 'text/html')});
				assert: part stream contents = ''.
		]

		testNextPartWithPartBiggerThenMaxMemory [
			writeStream := '' writeStream.
			writeStream cr; nl;
				nextPutAll: '--foo'; cr; nl;
				nextPutAll: 'Content-Type: text/html'; cr; nl;
				cr; nl;
				nextPutAll: 'bar';
				cr; nl;
				nextPutAll: '--foo--'.

			reader := MultipartParser on: writeStream readStream boundary: 'foo' maxMemory: 2.
			part := reader nextPart.

			self
				assert: part boundary = 'foo';
				assert: part headers = (LookupTable from: {'Content-Type' -> (Header name: 'Content-Type' value: 'text/html')});
				assert: part stream contents = 'bar';
				assert: nil = reader nextPart.
		]
	]

]
