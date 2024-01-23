private
fetch: urlString method: methodString optionsDo: optionsBlock

	| code content headers numberOfHeaders rawHeaders response url |
	response := JS await:
		(JS
			fetch: urlString
			with:
				(JS Object new
					at: #method put: methodString;
					in: optionsBlock;
					yourself)).
	
	rawHeaders := JS Array from: response headers.
	numberOfHeaders := rawHeaders length - 1.
	headers := OrderedCollection new: numberOfHeaders streamContents: [:stream |
		0 to: numberOfHeaders do: [:i |
			| rawHeader |
			rawHeader := rawHeaders at: i.
			stream nextPut: (rawHeader at: 0) asString -> (rawHeader at: 1) asString]].
	
	content := (JS await: response text) asString.
	
	code := response status.
	url := response url asString.
	
	^ WebResponse new
		yarosHeaders: headers code: code;
		url: urlString;
		status: 'HTTP/1.1 ' "faked" , code; "for printString"
		content: content;
		yourself