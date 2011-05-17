TestCase subclass: HtmlTest [
	testEscape [
		self assert: '&amp;&#039;&quot;&lt;&gt;' = (Html escape: '&''"<>').
	]

	testEscapeComment [
		self assert: '--><!-- foo--><!-- bar--><!-- ' = (Html escapeComment: '--foo--bar--').
	]
]
