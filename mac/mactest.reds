Red/System []
#include %hid.reds
devs: declare hid/hid-device-info
cur-dev: declare hid/hid-device-info
probe "before hid/enumerate"
devs: hid/enumerate 0 0

probe "jnjhnhuiuijuijiu"
cur-dev: devs
while [as logic! cur-dev] [
    probe ["type:" cur-dev/id ]
    probe ["path:" cur-dev/path]
    print "serial-number:" 
    hid/wprintf cur-dev/serial-number 
    probe " "
    print "manufacturer-string:" 
    hid/wprintf cur-dev/manufacturer-string
    probe " "
    print "product-string:" 
    hid/wprintf cur-dev/product-string
    probe " "
    probe ["release-number:" cur-dev/release-number]
    probe ["interface-number:" cur-dev/interface-number]
    cur-dev: cur-dev/next
    probe " "
] 
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
probe hid/read_timeout dev dd 1024 3000
dump-hex dd 
