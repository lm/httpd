TestCase subclass: HeaderTest [
	testValueCantContainsCRLF [
		[Header name: 'h' value: Character nl asString.
		self assert: false]
			on: Error do: [].

		[Header name: 'h' value: Character lf asString.
		self assert: false]
			on: Error do: [].
	]

	testEqualityOperator [
		| header |

		header := (Header name: 'foo' value: 'bar').

		self
			assert: header = header copy;
			deny: header = nil;
			deny: header = (Header name: 'foo2' value: 'bar');
			deny: header = (Header name: 'foo' value: 'bar2').
	]

	testNameIsCanonicalized [
		self
			assert: 'Content-Type' = (Header name: 'cONtent-tYpe' value: '') name;
			assert: '-Content-Type' = (Header name: '-cONtent-tYpe' value: '') name;
			assert: 'Content-Type-' = (Header name: 'cONtent-tYpe-' value: '') name.
	]

	testValueNotContainsLeadingAndTrailingSeparators [
		self assert: 'foo bar' = (Header fromString: 'h:  foo bar  ') value.
	]

	testFromString [
		self
			assert: (Header name: 'Foo' value: 'bar') = (Header fromString: 'Foo:	bar  ');
			assert: (Header name: 'Foo' value: 'bar') = (Header fromString: 'foo:bar').
	]

	testWithValue [
		self assert: 'barpref' = ((Header name: 'foo' value: 'bar') withValue: 'pref') value.
	]

	testPrintOn [
		| writeStream |

		writeStream := WriteStream on: String new.

		(Header name: 'Foo' value: 'bar') printOn: writeStream.
		self assert: '''Foo: bar''' = writeStream contents.
	]

	testValues [
		self assert: #('bar' 'foo') asOrderedCollection = (Header name: 'Header' value: 'bar;a=1;b=2, foo;c=3;d=4') values.
	]

	testsValuesParameters [
		| header |

		header := Header name: 'Header' value: 'bar;a=1;b=2, foo;c=3'.

		self
			assert: (LookupTable from: {'a' -> '1'. 'b' -> '2'}) = (header parametersAt: 1);
			assert: (LookupTable from: {'c' -> '3'}) = (header parametersAt: 2).
	]
]
