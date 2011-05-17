Namespace current: Responding [

	Object subclass: Responder [

		<category: 'Http Processing'>
		<comment: 'I generate response to HTTP request'>

		respondTo: aRequest on: aResponse [
			<category: 'responding'>

			self subclassResponsibility.
		]

		respondBadRequestOn: aResponse [
			<category: 'error responding'>
			"Note that this method accepts only a response, there is no valid HTTP request"

			^self renderErrorPageOn: aResponse
				code: 400
				message: 'Bad Request'
				description: 'The request could not be understood.'.
		]

		respondRequestTimeoutOn: aResponse [
			<category: 'error responding'>
			"Note that this method accepts only a response, there is no valid HTTP request"

			^self renderErrorPageOn: aResponse
				code: 408
				message: 'Request Timeout'
				description: 'The client did not produce a request within the time that the server was prepared to wait.'
		]

		respondNotFoundTo: aRequest on: aResponse [
			<category: 'error responding'>

			^self renderErrorPageOn: aResponse
				code: 404
				message: 'Not found'
				description: 'The requested URI <b>', (Html escapeSkipQuotes: aRequest uri asString),
					'</b> was not found on this server.'
		]

		respondInternalServerError: anError to: aRequest on: aResponse [
			<category: 'error responding'>

			^self renderErrorPageOn: aResponse
				code: 500
				message: 'Internal Server Error'
				description: 'Something went wrong...'
		]

		renderErrorPageOn: response code: code message: message description: description [
			<category: 'error responding'>

			| stream |

			response headersSent ifTrue: [^self].

			stream := (String new: 400) writeStream.
			stream nextPutAll: '<html><head><style>html, body{font: 12pt/1.4 Tahoma; background:#F0F0F0; text-align:center} div{width:600px; margin: 60px auto; padding:30px; color:#fff; background:#1C446F; border-radius:5px; box-shadow:1px 1px 1px #ccc} h1{margin:0; text-shadow:1px 3px 0 #173554; font-weight:normal; font-size:2.5em} pre{color: #B4C5D2; font-size: 10pt} p{color: #f1f3f6}</style><title>';
				nextPutAll: (Html escapeSkipQuotes: message);
				nextPutAll: '</title></head>';
				nextPutAll: '<body><div><h1>'; nextPutAll: (Html escapeSkipQuotes: message);
				nextPutAll: '</h1><p>'; nextPutAll: description; nextPutAll: '</p>';
				nextPutAll: '<p><pre>HTTP '; nextPutAll: code printString; nextPutAll: '</pre></p></div></body></html>'.
			"response nextPutGarbageOn: stream."

			response code: code;
				headerAt: 'Content-Type' put: 'text/html';
				headerAt: 'Content-Length' put: stream size asString.
			stream readStream nextPutAllOn: response stream.

			^response
		]
	]

]
