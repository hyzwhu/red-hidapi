Red/System []
#include %red-hidapi.reds
; #define LOWORD(param) (param and FFFFh << 16 >> 16)    ;-- trick to force sign extension
; #define HIWORD(param) (param >> 16)
;--test
res: declare integer! 
buf: declare c-string!
vendor-id: declare integer! 
product-id: declare integer!
wstr: as int-ptr! allocate 128
handle: declare windows-hidapi/hid-device
i: declare integer!
devs: declare windows-hidapi/hid-device-info
cur-dev: declare windows-hidapi/hid-device-info
devs: windows-hidapi/hid-enumerate 0 
cur-dev: devs
;--test hid-enumerate
; while [as logic! cur-dev] [
;     vendor-id: HIWORD(cur-dev/id)
;     product-id: LOWORD(cur-dev/id)
;     probe ["type:" cur-dev/id ]
;     probe ["path:" cur-dev/path]
;     print "serial-number:" 
;     windows-hidapi/wprintf cur-dev/serial-number 
;     probe " "
;     print "manufacturer:" 
;     windows-hidapi/wprintf cur-dev/manufacturer-string
;     probe " "
;     print "product:" 
;     windows-hidapi/wprintf cur-dev/product-string
;     probe " "
;     probe ["release:" cur-dev/release-number]
;     probe ["interface:" cur-dev/interface-number]
;     cur-dev: cur-dev/next
;     probe " "
; ]
windows-hidapi/hid-free-enumeration devs 
hid-test: declare windows-hidapi/hid-device
s: declare c-string!
s: #u16 "1687DBC3F859CCFFC36D5F71"
hid-test: windows-hidapi/hid-open 0000534Ch 00000001h s 
probe ["hid-test:"hid-test]
