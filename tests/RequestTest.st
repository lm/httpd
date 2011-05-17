TestCase subclass: RequestTest [
	testContent [
		| writeStream |

		writeStream := (WriteStream on: String new)
			nextPutAll: 'GET http://test/path?query=1 HTTP/1.1'; cr; nl;
			nextPutAll: 'Content-Length: 4'; cr; nl; cr; nl;
			nextPutAll: 'body123';
			yourself.

		self assert: (Request readFrom: writeStream readStream) content contents = 'body'.
	]
]
