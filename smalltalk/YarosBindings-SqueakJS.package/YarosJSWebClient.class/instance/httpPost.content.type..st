methods
httpPost: urlString content: postData type: contentType

	^ self fetch: urlString method: 'POST' optionsDo: [:options |
		options at: #body put: postData]