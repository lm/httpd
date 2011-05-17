Namespace current: Responding [

	Responder subclass: FileSystemResponder [
		| rootDirectory |

		FileSystemResponder class >> rootDirectory: aDirectory [
			<category: 'instance creation'>

			^super new initializeRootDirectory: aDirectory
		]

		FileSystemResponder class >> new [
			<category: 'instance creation'>

			self shouldNotImplement.
		]

		initializeRootDirectory: aDirectory [
			<category: 'initializing'>

			rootDirectory := aDirectory.
		]

		respondTo: aRequest on: aResponse [
			<category: 'responding'>

			| file uri path |

			file := rootDirectory.
			uri := aRequest uri.
			path := (FilePath fullNameFor: '/', uri path) copyFrom: 2.

			path isEmpty ifFalse: [
				file := file at: path.
				file isDirectory ifTrue: [path := path, '/']].

			uri path ~= path ifTrue: [
				^(RedirectResponder permanentlyTo: (uri copy path: path))
					respondTo: aRequest on: aResponse].

			(file isDirectory and: [(file / 'index.html') isReadable]) ifTrue: [
				file := file / 'index.html'].

			file isReadable ifFalse: [^self respondNotFoundTo: aRequest on: aResponse].
			file isDirectory
				ifTrue: [self respondDirectoryIndex: file to: aRequest on: aResponse]
				ifFalse: [(FileResponder with: file) respondTo: aRequest on: aResponse].
		]

		respondDirectoryIndex: aDirectory to: aRequest on: aResponse [
			<category: 'responding'>

			self respondNotFoundTo: aRequest on: aResponse.
		]
	]

]
