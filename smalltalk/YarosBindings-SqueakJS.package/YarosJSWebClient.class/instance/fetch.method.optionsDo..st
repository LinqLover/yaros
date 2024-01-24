private
fetch: urlString method: methodString optionsDo: optionsBlock

	| options response rawHeaders numberOfHeaders headers code url content |
	options := JS Object new.
	options at: #method put: methodString.
	self timeout ifNotNil: [:seconds |
		(JS eval: '(options, ms) => {
			const ctrl = new AbortController();
			setTimeout(() => ctrl.abort(), ms);
			options.signal = ctrl.signal;
		}') call: options with: seconds * 1000].
		
	options in: optionsBlock.
	
	response := (JS fetch: urlString with: options) asSqueakPromise await.
	
	rawHeaders := JS Array from: response headers.
	numberOfHeaders := rawHeaders length - 1.
	headers := OrderedCollection new: numberOfHeaders streamContents: [:stream |
		0 to: numberOfHeaders do: [:i |
			| rawHeader |
			rawHeader := rawHeaders at: i.
			stream nextPut: (rawHeader at: 0) asString -> (rawHeader at: 1) asString]].
	
	code := response status.
	url := response url asString.
	content := response text asSqueakPromise await asString.
	
	^ WebResponse new
		yarosHeaders: headers code: code;
		url: url;
		status: 'HTTP/1.1 ' "faked" , code; "for printString"
		content: content;
		yourself