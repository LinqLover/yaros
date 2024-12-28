proxies
resolveProxyForm

	| data |
	data := self yarosAsBase64String.
	^ ImageReadWriter formFromStream:
		(Base64MimeConverter mimeDecodeToBytes: data readStream)