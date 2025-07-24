control
start
	self flag: #todo. "
	- add installation logic (Metacello + clone js files (or can we serve them from image?) [+ deno installation])
		For now, you have to do it manually:
			https://github.com/LinqLover/yaros"
	
	self startJsProcess.
	self startYaros.