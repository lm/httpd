Eval [
	PackageLoader fileInPackage: #Http.
	Namespace current import: Http.

	(thisContext currentFileName asFile parent / 'MyApplication.st') fileIn.

	server := Server
		responder: MyApplication new
		port: (Smalltalk arguments at: 1 ifAbsent: [8080]) asNumber.

	server addDependent: (Logger logOn: Transcript).
	server serve.

	stdin next.
	server stop.
]
