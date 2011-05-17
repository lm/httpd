Namespace current: Parsing [

	TestCase subclass: PercentEncodingTest [
		testDecode [
			| encoding |

			encoding := PercentEncoding new.

			self
				assert: (encoding decode: 'foo%40bar') = 'foo@bar';
				assert: (encoding decode: '%40bar') = '@bar';
				assert: (encoding decode: 'foo%40') = 'foo@';
				assert: (encoding decode: 'foo%') = 'foo%'.
		]
	]

]
