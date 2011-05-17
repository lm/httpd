Namespace current: Responding [

	Responder subclass: RedirectResponder [
		| code uri |

		RedirectResponder class >> code: anInteger uri: aString [
			<category: 'instance creation'>

			^self new initializeCode: anInteger uri: aString
		]

		RedirectResponder class >> permanentlyTo: aString [
			<category: 'instance creation'>

			^self code: 301 uri: aString
		]

		RedirectResponder class >> temporaryTo: aString [
			<category: 'instance creation'>

			^self code: 307 uri: aString
		]

		initializeCode: anInteger uri: aString [
			<category: 'initializing'>

			code := anInteger.
			uri := aString.
		]

		respondTo: aRequest on: aResponse [
			<category: 'responding'>

			aResponse
				code: code;
				headerAt: 'Location' put: uri;
				headerAt: 'Content-Length' put: '0'.
		]
	]

]
