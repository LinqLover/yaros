as yet unclassified
todo
	"
	network:
	* chunk-based approach is horrible: eliminate workarounds in chunk writing, send correct headers, fix timeouts
	* switch to websockets, or simple http calls for now
	* fi
	
	trunk: resolveProxy in all primitives
	
	features:
	* evaluate messagesends on correct stack to make executeArounds methods usable (processId in requests?)
	* process priorities?
	* optimize: avoid redundant handhsakes in messagesend>>value?
	* exception handling - ideally resumable from remote
	"