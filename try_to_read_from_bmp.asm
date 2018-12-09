.include "basics.asm"
.include "functions.asm"

.text
main:
	open_file($s7)
	FILE_TEST($s7)
	
	
	END