Red/System []
#include %hid.reds

;-- test hid/enumerate function
devs: declare hid/hid-device-info
cur-dev: declare hid/hid-device-info
probe "hid/enumerate"
devs: hid/enumerate 0 0
cur-dev: devs
while [as logic! cur-dev] [
    probe ["type:" cur-dev/id ]
    probe ["path:" cur-dev/path]
    print "serial-number:" 
    hid/wprintf cur-dev/serial-number
	dump-hex as byte-ptr! cur-dev/serial-number 
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

;-- test hid/read and hid/write fuction--
dev: declare int-ptr! 
; dev: hid/open 0000534Ch 00000001h null 
; product: false	;--open trezor
dev: hid/open 00002C97h 00000001h null
pro: true	;--open leger nano  s 

data: either pro [
	[
	#"^(00)" #"^(01)" #"^(01)" #"^(05)" #"^(00)" #"^(00)" #"^(00)" #"^(16)"
	#"^(E0)" #"^(02)" #"^(00)" #"^(00)" #"^(11)" #"^(04)" #"^(80)" #"^(00)"
	#"^(00)" #"^(2C)" #"^(80)" #"^(00)" #"^(00)" #"^(3C)" #"^(80)" #"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"
] ;--data for leger nano s 
][
	[
	#"^(00)" #"?" #"#" #"#" #"^(00)" #"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"
]	;--data for trezor 
]	

?? dev 
probe ["size: " size? data]
hid/write dev data size? data

dd1: allocate 1024
set-memory dd1 null-byte 1024
probe "jdkfjaskldf"
probe hid/read-timeout dev dd1 1024 3000
; probe hid/read dev dd 1024
dump-hex dd1 

;--test hid/get_string function--
;--get_manufacturer_string 
dd: as c-string! allocate 1024
probe hid/get_manufacturer_string dev dd 255
dump-hex as byte-ptr! dd  

;--get_product_string
probe hid/get_product_string dev dd 255 
dump-hex as byte-ptr! dd 

;--get_serial_string
probe hid/get_serial_number_string dev dd 255
dump-hex as byte-ptr! dd 

;--get_indexed_string
probe hid/get_indexed_string dev 2 dd 255
dump-hex as byte-ptr! dd 
 