Namespace current: Responding [

	FileSystemResponder subclass: DirectoryIndexResponder [
		respondDirectoryIndex: aDirectory to: aRequest on: aResponse [
			<category: 'responding'>

			| writer title uri entries class |

			writer := aResponse writer.
			title := 'Index of /', (Html escapeSkipQuotes: aRequest uri path).
			entries	:= aDirectory entryNames asSortedCollection.
			entries remove: '.'.

			aResponse headerAt: 'Content-Type' put: 'text/html; charset=UTF-8'.

			writer
				nextPutAll: '<!DOCTYPE html>'; nl;
				nextPutAll: '<html>'; nl;
				nextPutAll: '<head>'; nl;
				nextPutAll: '	<style>
		html,body {font:12pt/1.4 Tahoma;background:#F0F0F0;text-align:center}
		div {width:800px;margin:60px auto;color:#fff;background:#1C446F;border-radius:5px;box-shadow:1px 1px 1px #ccc}
		h1 {margin:0;padding:15px 30px;text-shadow:1px 3px 0 #173554;font-weight:normal;font-size:1.8em;border-bottom:1px solid rgba(0,0,0,.5);border-top:1px solid rgba(255,255,255,.3)}
		pre {color:#B4C5D2;font-size:10pt}
		p {color:#f1f3f6}
		ul {margin:0;padding:0;list-style:none;background:#fff;text-align:left;border-radius:3px}
		li {padding:0;margin:0}
		li a {padding:4px;padding-left:22px;display:block;color:#1C446F}
		li:nth-child(odd) a {background-color:#F4F6F8;border-radius:3px}
		.file {background:url("data:image/gif;base64,R0lGODlhCgAKAJEDALOzs7+/v5mZmf///yH5BAEAAAMALAAAAAAKAAoAAAIWHA4Tw4YjFkNJxPkapmdzT4EZN5JJAQA7") no-repeat 6px center}
		.dir {background:url("data:image/gif;base64,R0lGODlhCgAKAKIEALOzs5mZmaamptnZ2f///wAAAAAAAAAAACH5BAEAAAQALAAAAAAKAAoAAAMRSLocHoORF4QEOOvNu/9gqCUAOw==") no-repeat 6px center}
	</style>'; nl;
				tab;
				nextPutAll: '<title>';
				nextPutAll: title;
				nextPutAll: '</title>'; nl;
				nextPutAll: '</head>'; nl;
				nextPutAll: '<body>'; nl;
				nextPutAll: '<div>'; nl;
				tab;
				nextPutAll: '<h1>';
				nextPutAll: title;
				nextPutAll: '</h1>'; nl;
				tab;
				nextPutAll: '<ul>'; nl.

			entries do: [ :entry |
				uri := aRequest uri copy.
				uri path: (uri path isEmpty ifTrue: [entry] ifFalse: [uri path, entry]).
				class := 'file'.

				(aDirectory / entry) isDirectory ifTrue: [
					uri path: uri path, '/'.
					class := 'dir'].

				writer
					tab: 2;
					nextPutAll: '<li><a href="';
					print: uri;
					nextPutAll: '" class="';
					nextPutAll: class;
					nextPutAll: '">';
					nextPutAll: entry;
					nextPutAll: '</a></li>';
					nl].

			writer
				tab;
				nextPutAll: '</ul>'; nl;
				nextPutAll: '</div>'; nl;
				nextPutAll: '</body>'; nl;
				nextPutAll: '</html>';
				flushEnd.
		]
	]

]
