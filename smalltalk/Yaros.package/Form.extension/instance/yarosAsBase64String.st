*Yaros-converting
yarosAsBase64String

	^ (ByteArray streamContents: [:stream |
		PNGReadWriter putForm: self onStream: stream])
			base64Encoded