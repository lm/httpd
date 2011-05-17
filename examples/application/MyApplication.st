Http.Responding.Responder subclass: MyApplication [
	Posts := OrderedCollection new.

	respondTo: aRequest on: aResponse [
		aRequest hasFormData ifTrue: [
			Posts add: (aRequest formData at: 'content')].

		self respondMainPageTo: aRequest on: aResponse.
	]

	respondMainPageTo: aRequest on: aResponse [
		| writer |

		writer := aResponse writer.

		aResponse headerAt: 'Content-Type' put: 'text/html; charset=utf-8'.
		writer nextPutAll:
'<html>
<head>
	<title>My application</title>
</head>
<body>
	<ul>
'.

		Posts do: [ :post |
			writer
				tab: 2;
				nextPutAll: '<li>';
				nextPutAll: (Http.Html escape: post);
				nextPutAll: '</li>';
				nl].

		writer nextPutAll:
'	</ul>
	<form method="post" action="">
		<input type="text" name="content">
		<input type="submit" name="post">
	</form>
</body>
</html>'.

		writer flushEnd.
	]
]
