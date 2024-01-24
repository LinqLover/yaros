private
fetch: urlString method: methodString optionsDo: optionsBlock

	| request options code content statusText |
	options := JS Object new.
	options in: optionsBlock.
	
	request := JS XMLHttpRequest new.
	request open: methodString url: urlString async: false.
	request send: (options at: #body).
	
	code := request status.
	statusText := request statusText asString.
	content := request responseText asString.
	
	^ WebResponse new
		yarosHeaders: OrderedCollection new code: code;
		url: urlString;
		status: 'HTTP/1.1 ' "faked" , code , ' ' , statusText; "for printString"
		content: content;
		yourself