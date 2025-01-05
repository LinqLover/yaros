proxies
resolveProxyColorMap

	| data |
	nil haltIf: self className ~= #Bitmap.
	data := self in: [:bitmap | bitmap compressToByteArray base64Encoded].
	^ Bitmap decompressFromByteArray: (data base64DecodedAs: ByteArray)