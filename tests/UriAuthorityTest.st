TestCase subclass: UriAuthorityTest [
	| authority |

	testFromStringWithAllComponents [
		authority := UriAuthority fromString: 'user:pass@example.com:666'.
		self
			assert: authority user = 'user';
			assert: authority password = 'pass';
			assert: authority host = 'example.com';
			assert: authority port = 666.
	]

	testFromStringWithoutPort [
		authority := UriAuthority fromString: 'user:pass@example.com'.
		self
			assert: authority user = 'user';
			assert: authority password = 'pass';
			assert: authority host = 'example.com';
			assert: authority port isNil.
	]

	testFromStringWithoutPassword [
		authority := UriAuthority fromString: 'user@example.com'.
		self
			assert: authority user = 'user';
			assert: authority password isNil;
			assert: authority host = 'example.com';
			assert: authority port isNil.
	]

	testFromStringWithoutUserinfo [
		authority := UriAuthority fromString: 'example.com'.
		self
			assert: authority user isNil;
			assert: authority password isNil;
			assert: authority host = 'example.com';
			assert: authority port isNil.
	]

	testEqualityOperator [
		authority := UriAuthority fromString: 'user:pass@example.com:500'.
		self
			assert: authority = (UriAuthority fromString: 'user:pass@example.com:500');
			deny: authority = (UriAuthority fromString: 'example.com:500');
			deny: authority = (UriAuthority fromString: 'user:pass@example.com:600');
			deny: authority = (UriAuthority fromString: 'user:pass@example.org:600').
	]

	testHash [
		self assert: (UriAuthority fromString: 'example.com') hash = (UriAuthority fromString: 'example.com') hash.
	]

	testPrintOn [

	]
]
