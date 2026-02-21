*Yaros-serializing
yarosDeserialize: data

	^ ImageReadWriter formFromStream:
		(Base64MimeConverter mimeDecodeToBytes: data readStream)