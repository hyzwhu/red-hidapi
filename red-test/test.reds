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
writeOk: declare integer!
writeTest: func [
		/local
		msg-size   	 	[integer!]
		msg-id     	 	[integer!]
		buf         	[byte-ptr!]
		i           	[integer!]
	][
		buf: as byte-ptr! allocate 64
        msg-size: 11
		i: 21
		msg-id: 26
        buf/1: #"?"
		buf/2: #"#"
		buf/3: #"#"
		buf/4: as byte! ((msg-id >> 8) and 000000FFh)
		buf/5: as byte! (msg-id and 000000FFh)
		buf/6: as byte! ((msg-size >> 24) and 000000FFh)
		buf/7: as byte! ((msg-size >> 16) and 000000FFh)
		buf/8: as byte! ((msg-size >> 8) and 000000FFh)
		buf/9: as byte! (msg-size and 000000FFh)
		buf/10: as byte! 8
		buf/11: as byte! 1
		buf/12:  as byte!  18
        buf/13: as byte! 7
        buf/14: as byte! 116
        buf/15: as byte! 101
        buf/16: as byte! 115
        buf/17: as byte! 116
        buf/18: as byte! 105
        buf/19: as byte! 111
        buf/20: as byte! 103
	    until [
			buf/i: null-byte
			i: i + 1
		    i = 65
		]
        writeOk: windows-hidapi/hid-write hid-test buf 64
        probe ["writeOk:" writeOk]
	]
writeTest

