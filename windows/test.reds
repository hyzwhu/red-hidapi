Red/System []

#include %hid.reds

;-- Test ledger nano s --

dev: hid/open 00002C97h 00000001h null
?? dev

data: [
	#"^(00)" #"^(01)" #"^(01)" #"^(05)" #"^(00)" #"^(00)" #"^(00)" #"^(16)"
	#"^(E0)" #"^(02)" #"^(00)" #"^(00)" #"^(11)" #"^(04)" #"^(80)" #"^(00)"
	#"^(00)" #"^(2C)" #"^(80)" #"^(00)" #"^(00)" #"^(3C)" #"^(80)" #"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"
]

probe ["size: " size? data]
hid/write dev data size? data

dd: allocate 1024
set-memory dd null-byte 1024
probe "jdkfjaskldf"
probe hid/read-timeout dev dd 1024 3000
dump-hex dd 

probe hid/read-timeout dev dd 1024 3000
dump-hex dd 