Red/System []
#include %hid.reds
devs: declare hid/hid-device-info
cur-dev: declare hid/hid-device-info
; probe "hid/enumerate"
;devs: hid/enumerate 0000534Ch 00000001h
; devs: hid/enumerate 0 0
; probe "jnjhnhuiuijuijiu"
; cur-dev: devs
; while [as logic! cur-dev] [
;     probe ["type:" cur-dev/id ]
;     probe ["path:" cur-dev/path]
;     print "serial-number:" 
;     hid/wprintf cur-dev/serial-number
; dump-hex as byte-ptr! cur-dev/serial-number 
;     probe " "
;     print "manufacturer-string:" 
;     hid/wprintf cur-dev/manufacturer-string
;     probe " "
;     print "product-string:" 
;     hid/wprintf cur-dev/product-string
;     probe " "
;     probe ["release-number:" cur-dev/release-number]
;     probe ["interface-number:" cur-dev/interface-number]
;     cur-dev: cur-dev/next
;     probe " "
; ] 
probe "begain to open func"
dev: declare int-ptr!
dev: hid/open 0000534Ch 00000001h null
?? dev 
;#if OS = 'Windows [#"^(00)"]
data: [
	#"?" #"#" #"#" #"^(00)" #"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"
]

;hid/set_nonblocking dev 1 
probe ["size: " size? data]
probe "hello123"
b: declare integer!
b: hid/write dev data 64 ;size? data
?? b 
dd: allocate 1024
set-memory dd null-byte 1024
probe "jdkfjaskldf"
h: declare integer!
; h: hid/read_timeout dev as c-string! dd 1024 10000
h: hid/read dev dd 1024
?? h
dump-hex dd

