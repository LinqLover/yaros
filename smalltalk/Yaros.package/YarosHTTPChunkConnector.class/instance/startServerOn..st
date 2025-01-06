control
startServerOn: outputStreamBlock

	server := WebServer new.
	server listenOn: self clientPort.
	server addService: '/comm' action: [:req |
		| response outputStream gen |
		[:exit | req
			send200Response: (('0', String crlf ", String crlf") convertToWithConverter: UTF8TextConverter new)
			contentType: 'text/plain; charset=utf-8'
			do: [:resp |
				resp headerAt: 'transfer-encoding' put: 'chunked'.
				response := resp.
				"req sendResponse: response contentStream: ((('0' , String crlf) convertToWithConverter: UTF8TextConverter new) readStream collect: #yourself) size: 3."
				"resp writeOn: req stream.
				req stream flush."
				exit value]] valueWithExit.
		Transcript showln: ('{1}: server opened' format: {self}).
		self unblockServerBlock value.
		outputStream := outputStreamBlock value.
		gen := Generator on: [:g | | msg |
			g nextPut: String crlf. "is always ignored???"
			outputStream do: [:ea |
				g nextPut: (ea ifNil: ['{}']) , String cr]].
		gen do: [:msg | | rawmsg |
			"Transcript showln: ('{1}: send: {2}' format: {self. msg})."
			rawmsg := ((((msg size printStringBase: 16) , String crlf , msg , String crlf ", '0' , String crlf"))).
			response streamFrom: ((((rawmsg size printStringBase: 16) , String crlf , rawmsg , String crlf , '0' , String crlf) convertToWithConverter: UTF8TextConverter new) readStream collect: #yourself) to: req stream size: nil progress: nil.
			0.1 seconds wait "otherwise messages are lost???"].
		req close.
		Transcript showln: ('{1}: server closed' format: {self})].