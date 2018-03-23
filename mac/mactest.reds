Red/System []
#include %hid.reds
devs: declare hid/hid-device-info
cur-dev: declare hid/hid-device-info
probe "before hid/enumerate"
devs: hid/enumerate 0 0
; cur-dev: devs
; while [as logic! cur-dev] [
;     probe ["type:" cur-dev/id ]
;     probe ["path:" cur-dev/path]
;     print "serial-number:" 
;     hid/wprintf cur-dev/serial-number 
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