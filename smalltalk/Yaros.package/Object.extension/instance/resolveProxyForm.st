*Yaros-proxies-pseudo-override
resolveProxyForm

	| data |
	data := self yarosAsBase64String.
	^ ImageReadWriter formFromStream:
		(Base64MimeConverter mimeDecodeToBytes: data readStream)