TestCase subclass: ChunkedWriterTest [
	| response writer expected |

	setUp [
		response := MockResponse new.
		writer := ChunkedWriter writeTo: response.
	]

	testFlushSendsTransferEncodingHeader [
		writer
			nextPut: $a;
			flush.

		self assert: response headers = (Dictionary from: {'Transfer-Encoding' -> 'chunked'}).
	]

	testFlushCopyContentsToResponseStream [
		writer
			nextPutAll: 'foobar';
			flush;
			nextPutAll: 'foo';
			flush.

		expected := (WriteStream on: String new)
			nextPut: $6; cr; nl;
			nextPutAll: 'foobar'; cr; nl;
			nextPut: $3; cr; nl;
			nextPutAll: 'foo'; cr; nl.

		self assert: response stream contents = expected contents.
	]

	testAutoFlush [
		writer
			chunkSize: 2;
			nextPut: $a;
			nextPut: $b.
		'cd' nextPutAllOn: writer.

		expected := '' writeStream
			nextPut: $2;  cr; nl;
			nextPutAll: 'ab';  cr; nl;
			nextPut: $2;  cr; nl;
			nextPutAll: 'cd';  cr; nl;
			contents.

		self assert: expected = response stream contents.
	]

	testFlushEnd [
		writer flushEnd.
		self assert: response stream contents = {$0. Character cr. Character nl. Character cr. Character nl} asString.
	]
]
