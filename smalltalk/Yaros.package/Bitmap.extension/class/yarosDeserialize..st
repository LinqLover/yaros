*Yaros-serializing
yarosDeserialize: data

	^ Bitmap decompressFromByteArray: (data base64Decoded asByteArray)