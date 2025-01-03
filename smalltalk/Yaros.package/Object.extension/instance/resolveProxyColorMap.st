*Yaros-proxies-pseudo-override
resolveProxyColorMap

	| data |
	nil haltIf: (self isKindOf: Bitmap) not.
	data := self in: [:bitmap | bitmap compressToByteArray base64Encoded].
	^ Bitmap decompressFromByteArray: (data base64DecodedAs: ByteArray)