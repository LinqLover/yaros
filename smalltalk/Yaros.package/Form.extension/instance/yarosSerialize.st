*Yaros-serializing
yarosSerialize

	^ (ByteArray streamContents: [:stream |
		PNGReadWriter putForm: self onStream: stream])
			base64Encoded