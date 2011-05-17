Object subclass: MockResponder [
	| responded respondedBadRequest respondedRequestTimeout |

	respondTo: aRequest on: aResponse [
		responded := true.
	]

	responded [
		^responded notNil
	]

	respondBadRequestOn: aResponse [
		respondedBadRequest := true.
	]

	respondedBadRequest [
		^respondedBadRequest notNil
	]

	respondRequestTimeoutOn: aResponse [
		respondedRequestTimeout := true.
	]

	respondedRequestTimeout [
		^respondedRequestTimeout notNil
	]
]
