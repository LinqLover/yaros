*Yaros-proxies-pseudo-override
resolveProxyArray

	^ (Array new: self size)
		fillFrom: self with: [:ea | ea]