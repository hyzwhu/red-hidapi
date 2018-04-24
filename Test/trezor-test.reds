Red/System [
	Title:	"Hidapi Test for Trezor"
	Author: "Huang Yongzhao"
	File: 	%trezor-test.reds
	Needs:	View
	Tabs: 	4
	Rights:  "Copyright (C) 2018 Red Foundation. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]
#switch OS [
		Windows  [#include %../HID/windows.reds]
		macOS	 [#include %../HID/macOS.reds]
		#default [#include %../HID/linux.reds]
	]
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
dev: hid/open 0000534Ch 00000001h null 

data: [
	#if OS = 'Windows [#"^(00)"] #"?" #"#" #"#" #"^(00)" #"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"#"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"
]	;--data for trezor 

#either OS = 'Windows [
	data1: [
		#"S" 	#"^(00)"   	#"a"   #"^(00)"
		#"t"   	#"^(00)" 	#"o"   #"^(00)"
		#"s"   	#"^(00)" 	#"h"   #"^(00)"
		#"i"   	#"^(00)" 	#"L"   #"^(00)"
		#"a"   	#"^(00)" 	#"b"   #"^(00)"
		#"s"  	#"^(00)"
	]
	data2: [
		#"U"   #"^(00)" #"2"        #"^(00)"
		#"F"   #"^(00)" #" "    	#"^(00)"
		#"I"   #"^(00)" #"n"   		#"^(00)"
		#"t"   #"^(00)" #"e"   		#"^(00)"
		#"r"   #"^(00)" #"f"   		#"^(00)"
		#"a"   #"^(00)" #"c"   		#"^(00)"
		#"e"   #"^(00)"
	] 
	data21: [
		#"T"	#"^(00)"	#"R"	#"^(00)"
		#"E"	#"^(00)"
	]
	data3: [
		#"1"   #"^(00)" #"6"   #"^(00)"
		#"8"   #"^(00)" #"7"   #"^(00)"
		#"D"   #"^(00)" #"B"   #"^(00)"
		#"C"   #"^(00)" #"3"   #"^(00)"
		#"F"   #"^(00)" #"8"   #"^(00)"
		#"5"   #"^(00)" #"9"   #"^(00)"
		#"C"   #"^(00)" #"C"   #"^(00)"
		#"F"   #"^(00)" #"F"   #"^(00)"
		#"C"   #"^(00)" #"3"   #"^(00)"
		#"6"   #"^(00)" #"D"   #"^(00)"
		#"5"   #"^(00)" #"F"   #"^(00)"
		#"7"   #"^(00)" #"1"   #"^(00)"
	]
	data4: [
		#"?"	#"#"	#"#"	#"^(00)"
	]
][
	data1: [
		#"S" #"^(00)" #"^(00)" #"^(00)" #"a" #"^(00)" #"^(00)" #"^(00)"
		#"t" #"^(00)" #"^(00)" #"^(00)" #"o" #"^(00)" #"^(00)" #"^(00)"
		#"s" #"^(00)" #"^(00)" #"^(00)" #"h" #"^(00)" #"^(00)" #"^(00)"
		#"i" #"^(00)" #"^(00)" #"^(00)" #"L" #"^(00)" #"^(00)" #"^(00)"
		#"a" #"^(00)" #"^(00)" #"^(00)" #"b" #"^(00)" #"^(00)" #"^(00)"
		#"s" #"^(00)" #"^(00)" #"^(00)"
	]
	data2: [
		#"T" #"^(00)" #"^(00)" #"^(00)" #"R" #"^(00)" #"^(00)" #"^(00)"
		#"E" #"^(00)" #"^(00)" #"^(00)" #"Z" #"^(00)" #"^(00)" #"^(00)"
		#"O" #"^(00)" #"^(00)" #"^(00)" #"R" #"^(00)" #"^(00)" #"^(00)"
	] 
	data21: [
		#"T"	#"^(00)"	#"R"	#"^(00)"
		#"E"	#"^(00)"
	]
	data3: [
		#"1" #"^(00)" #"^(00)" #"^(00)" #"6" #"^(00)" #"^(00)" #"^(00)"
		#"8" #"^(00)" #"^(00)" #"^(00)" #"7" #"^(00)" #"^(00)" #"^(00)"
		#"D" #"^(00)" #"^(00)" #"^(00)" #"B" #"^(00)" #"^(00)" #"^(00)"
		#"C" #"^(00)" #"^(00)" #"^(00)" #"3" #"^(00)" #"^(00)" #"^(00)"
		#"F" #"^(00)" #"^(00)" #"^(00)" #"8" #"^(00)" #"^(00)" #"^(00)"
		#"5" #"^(00)" #"^(00)" #"^(00)" #"9" #"^(00)" #"^(00)" #"^(00)"
		#"C" #"^(00)" #"^(00)" #"^(00)" #"C" #"^(00)" #"^(00)" #"^(00)"
		#"F" #"^(00)" #"^(00)" #"^(00)" #"F" #"^(00)" #"^(00)" #"^(00)"
		#"C" #"^(00)" #"^(00)" #"^(00)" #"3" #"^(00)" #"^(00)" #"^(00)"
		#"6" #"^(00)" #"^(00)" #"^(00)" #"D" #"^(00)" #"^(00)" #"^(00)"
		#"5" #"^(00)" #"^(00)" #"^(00)" #"F" #"^(00)" #"^(00)" #"^(00)"
		#"7" #"^(00)" #"^(00)" #"^(00)" #"1" #"^(00)" #"^(00)" #"^(00)"
	]
	data4: [
		#"?"	#"#"	#"#"	#"^(00)"
	]
]

hid/write dev data size? data
dd1: allocate 1024
set-memory dd1 null-byte 1024
;probe hid/read-timeout dev dd1 1024 3000
probe hid/read dev dd1 1024
either 0 = hid/strncmp as c-string! dd1 as c-string! data4 4 [
	probe "write and read success"
][
	probe "wriet and read fail"
]

;--test hid/get_string function--
;--get_manufacturer_string 
dd: as c-string! allocate 1024
probe hid/red-get-manufacturer-string dev dd 255
either 0 = hid/wcsncmp as c-string! data1 dd 11  [
	probe "get-manufacturer-string success"
][
	probe "get-manufacturer-string fail"
] 

;--get_product_string
probe hid/red-get-product-string dev dd 255 
either any [
	0 = hid/wcsncmp as c-string! data2 dd 6 
	0 = hid/wcsncmp as c-string! data21 dd 3
	] [
	probe "get-product-string success"
][
	probe "get-product-string fail"
] 

;--get_serial_string
probe hid/red-get-serial-number-string dev dd 255
either 0 = hid/wcsncmp as c-string! data3 dd 24  [
	probe "get-serial-number-string success"
][
	probe "get-serial-number-string fail"
] 

;--get_indexed_string
probe hid/red-get-indexed-string dev 2 dd 255
either any [
	0 = hid/wcsncmp as c-string! data2 dd 6 
	0 = hid/wcsncmp as c-string! data21 dd 3
	] [
	probe "get-product-string success"
][
	probe "get-product-string fail"
] 
;--close the dev 
hid/close dev   
;--if not sure the dev had been closed, try the func below
set-memory as byte-ptr! dd null-byte 1024
probe hid/red-get-indexed-string dev 2 dd 255
either any [
	0 = hid/wcsncmp as c-string! data2 dd 6 
	0 = hid/wcsncmp as c-string! data21 dd 3
	] [
	probe "get-product-string success"
][
	probe "get-product-string fail"
]  