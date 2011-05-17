Eval [
	PackageLoader fileInPackage: #Http.
	Namespace current import: Http.

	server := Server
		responder: (Responding.DirectoryIndexResponder rootDirectory: (thisContext currentFileName asFile parent / 'www'))
		port: (Smalltalk arguments at: 1 ifAbsent: [8080]) asNumber.

	server addDependent: (Logger logOn: Transcript).
	server serve.

	stdin next.
	server stop.
]
