Worker subclass: MockWorker [
	| request readRequestBlock response |

	request: aRequest [
		request := aRequest.
	]

	request [
		^request
	]

	readRequestBlock: aBlock [
		readRequestBlock := aBlock.
	]

	readRequestFrom: aConnection [
		readRequestBlock ifNotNil: [ :b | b value].
		^request
	]

	response [
		^response
	]

	response: aResponse [
		response := aResponse.
	]

	respondOn: aConnection [
		^response
	]
]
