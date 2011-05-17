HTTP server for GNU Smalltalk

Installation:

1)	You can build GNU Smalltalk STAR package from GIT repository
	by running included `package` script or download it from
	https://github.com/lm/httpd/downloads.

2)	To run server you just do something like this:

	PackageLoader fileInPackage: #Http.
	responder := Http.Responding.DirectoryIndexResponder rootDirectory: '/var/www' asFile.
	server := Http.Server responder: responder port: 8080.
	server serve.
	Processor activeProcess suspend.

	This will start serving index of /var/www directory on port 8080.