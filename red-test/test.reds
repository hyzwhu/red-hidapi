Red/System []
#include %red-hidapi.reds
; #define LOWORD(param) (param and FFFFh << 16 >> 16)    ;-- trick to force sign extension
; #define HIWORD(param) (param >> 16)
;--test
res: declare integer! 
buf: declare c-string!
vendor-id: declare integer!
product-id: declare integer!
wstr: as int-ptr! allocate 510
handle: declare windows-hidapi/hid-device
i: declare integer!
devs: declare windows-hidapi/hid-device-info
cur-dev: declare windows-hidapi/hid-device-info
devs: windows-hidapi/hid-enumerate 0 
cur-dev: devs
while [as logic! cur-dev] [
    vendor-id: HIWORD(cur-dev/id)
    product-id: LOWORD(cur-dev/id)
    probe ["type:" cur-dev/id ]
    probe ["path:" cur-dev/path]
    probe ["serial-number:" cur-dev/serial-number]
    probe ["manufacturer:" cur-dev/manufacturer-string]
    probe ["product:" cur-dev/product-string]
    probe ["release" cur-dev/release-number]
    probe ["interface:" cur-dev/interface-number]
    cur-dev: cur-dev/next
]
;windows-hidapi/hid-free-enumeration devs 