TestCase subclass: UriTest [
	| uri |

	testFromStringSlashInQuery [
		uri := Uri fromString: 'http://example.com?foo/bar'.
		self assert: uri query = (LookupTable from: {'foo/bar'->''}).
	]

	testFromStringSlashInFragment [
		uri := Uri fromString: 'http://example.com#foo/bar'.
		self assert: uri fragment = 'foo/bar'.
	]

	testFromStringWithAllComponents [
		uri := Uri fromString: 'http://user:pass@example.com/absolute/path/?foo=bar#fragment'.
		self
			assert: uri scheme = 'http';
			assert: uri authority host = 'example.com';
			assert: uri path = 'absolute/path/';
			assert: uri query = (LookupTable from: {'foo'->'bar'});
			assert: uri fragment = 'fragment'.
	]

	testFromStringWithoutFragment [
		uri := Uri fromString: 'http://user:pass@example.com/absolute/path/?foo=bar'.
		self
			assert: uri scheme = 'http';
			assert: uri authority host = 'example.com';
			assert: uri path = 'absolute/path/';
			assert: uri query = (LookupTable from: {'foo'->'bar'});
			assert: uri fragment = ''.
	]

	testFromStringOnlyWithPath [
		uri := Uri fromString: 'http://user:pass@example.com/absolute/path/'.
		self
			assert: uri scheme = 'http';
			assert: uri authority host = 'example.com';
			assert: uri path = 'absolute/path/';
			assert: uri query = LookupTable new;
			assert: uri fragment = ''.
	]

	testFromStringOnlyWithSchema [
		uri := Uri fromString: 'http://user:pass@example.com'.
		self
			assert: uri scheme = 'http';
			assert: uri authority host = 'example.com';
			assert: uri path = '';
			assert: uri query = LookupTable new;
			assert: uri fragment = ''.
	]

	testEqualityOperator [
		uri := Uri fromString: 'http://example.com/path/?foo=bar&bar=foo#fragment'.
		self
			assert: uri = uri copy;
			assert: uri = (Uri fromString: 'http://example.com/path/?bar=foo&foo=bar#fragment');
			deny: uri = (Uri fromString: 'http://example.com/path/?bar=foo&foo=2#fragment');
			deny: uri = (Uri fromString: 'http://example.com/pax/?bar=foo&foo=bar#fragment');
			deny: uri = (Uri fromString: 'https://example.com/path/?bar=foo&foo=bar#fragment').
	]

	testHash [
		uri := Uri fromString: 'http://example.com/path/?bar=foo&foo=bar#fragment'.
		self assert: uri hash = (Uri fromString: 'http://example.com/path/?bar=foo&foo=bar#fragment') hash.
	]

	testBaseUri [
		uri := Uri fromString: 'http://example.com/path/?bar=foo&foo=bar#fragment'.
		self assert: uri baseUri = (Uri fromString: 'http://example.com/').
	]

	testAsString [
		uri := Uri fromString: 'http://user%2A:pass%2A@host%2A:80/te%2Ast%2Ffoo/?foo%2Abar=test#test%2Atest'.
		self assert: uri asString = 'http://user%2A:pass%2A@host%2A/te%2Ast/foo/?foo%2Abar=test#test*test'.

		uri := Uri fromString: 'http://example.com:666/'.
		self assert: uri asString = 'http://example.com:666/'.
	]

	testWebalize [
		self assert: (Uri webalize: '#foo$#@bar@') = '-foo-bar-'.
	]
]
