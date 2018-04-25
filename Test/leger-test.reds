Red/System [
	Title:	"Hidapi Test for Ledger Nano s"
	Author: "Huang Yongzhao"
	File: 	%ledger-test.reds
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
dev: hid/open 00002C97h 00000001h null
pro: true	;--open leger nano  s 

data: [
	#"^(00)" #"^(01)" #"^(01)" #"^(05)" #"^(00)" #"^(00)" #"^(00)" #"^(16)"
	#"^(E0)" #"^(02)" #"^(00)" #"^(00)" #"^(11)" #"^(04)" #"^(80)" #"^(00)"
	#"^(00)" #"^(2C)" #"^(80)" #"^(00)" #"^(00)" #"^(3C)" #"^(80)" #"^(00)"
	#"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)" #"^(00)"
] ;--data for leger nano s 

#either OS = 'Windows [
	data1: [
		#"L"	#"^(00)"	#"e"   #"^(00)"
		#"d"	#"^(00)"	#"g"   #"^(00)"
		#"e"	#"^(00)"	#"r"   #"^(00)"
	]
	data2: [
		#"N"		#"^(00)"	#"a"	#"^(00)"
		#"n"		#"^(00)"	#"o"	#"^(00)"
		#" "		#"^(00)"	#"S"	#"^(00)"
	] 
	data3: [
		#"0"	#"^(00)"	#"0"	#"^(00)"
		#"0"	#"^(00)"	#"1"	#"^(00)"
	]
	data4: [
		#"^(01)"	#"^(01)"	#"^(05)"	#"^(00)"
	]
][
	data1: [
		#"L"	#"^(00)"	#"^(00)"	#"^(00)"	#"e"   #"^(00)"	#"^(00)"	#"^(00)"
		#"d"	#"^(00)"	#"^(00)"	#"^(00)"	#"g"   #"^(00)"	#"^(00)"	#"^(00)"
		#"e"	#"^(00)"	#"^(00)"	#"^(00)"	#"r"   #"^(00)"	#"^(00)"	#"^(00)"
	]
	data2: [
		#"N"		#"^(00)"	#"^(00)"	#"^(00)"	#"a"	#"^(00)"	#"^(00)"	#"^(00)"
		#"n"		#"^(00)"	#"^(00)"	#"^(00)"	#"o"	#"^(00)"	#"^(00)"	#"^(00)"
		#" "		#"^(00)"	#"^(00)"	#"^(00)"	#"S"	#"^(00)"	#"^(00)"	#"^(00)"
	] 
	data3: [
		#"0"	#"^(00)"	#"^(00)"	#"^(00)"	#"0"	#"^(00)"	#"^(00)"	#"^(00)"
		#"0"	#"^(00)"	#"^(00)"	#"^(00)"	#"1"	#"^(00)"	#"^(00)"	#"^(00)"
	]
	data4: [
		#"^(01)"	#"^(01)"	#"^(05)"	#"^(00)"
	]
]
;--test write and read funcs
hid/write dev data size? data
dd1: allocate 1024
set-memory dd1 null-byte 1024
probe hid/read dev dd1 1024
either 0 = hid/strncmp as c-string! dd1 as c-string! data4 4[
	probe "write and read success"
][
	probe "wriet and read fail"
] 

;--test hid/get_string function--
;--get_manufacturer_string 
dd: as c-string! allocate 1024
probe hid/red-get-manufacturer-string dev dd 255
either 0 = hid/wcsncmp as c-string! data1 dd 6  [
	probe "get-manufacturer-string success"
][
	probe "get-manufacturer-string fail"
] 

;--get_product_string
probe hid/red-get-product-string dev dd 255  
either 0 = hid/wcsncmp as c-string! data2 dd 6 [
	probe "get-product-string success"
][
	probe "get-product-string fail"
] 

;--get_serial_string
probe hid/red-get-serial-number-string dev dd 255
either 0 = hid/wcsncmp as c-string! data3 dd 4  [
	probe "get-serial-number-string success"
][
	probe "get-serial-number-string fail"
] 

;--get_indexed_string
probe hid/red-get-indexed-string dev 2 dd 255  ;--get product string
either 0 = hid/wcsncmp as c-string! data2 dd 6 [
	probe "get-product-string fail"
][
	probe "get-product-string success"
] 
;--close the dev 
hid/close dev   
;--if not sure the dev had been closed, try the func below
set-memory as byte-ptr! dd null-byte 1024
probe hid/red-get-indexed-string dev 2 dd 255
either 0 = hid/wcsncmp as c-string! data2 dd 6 [
	probe "get-product-string fail"
][
	probe "get-product-string success"
]
 