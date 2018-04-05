Red/System []

hid: context [
	#define	_IOC(inout group num len)   (inout | ((len & IOCPARM_MASK) << 16) | ((group) << 8) | (num))
	#define HIDIOCSFEATURE(len)    _IOC(_IOC_WRITE|_IOC_READ #"H"  0x06  len)
	#define HIDIOCGFEATURE(len)    _IOC(_IOC_WRITE|_IOC_READ #"H"  0x07  len)

	;--usb hid device property names
	device_string_names ["manufacturer"  "product"	"serial"]

	;--symbolic names for the properties above
	#define DEVICE_STRING_MANUFACTURER  0
	#define DEVICE_STRING_PRODUCT       1
	#define DEVICE_STRING_SERIAL		2
	#define DEVICE_STRING_COUNT			3

	hid-device-info: alias struct! [
			path 				[c-string!]
			id 					[integer!] ;vendor-id and product-id
			serial-number 		[c-string!]
			manufacturer-string [c-string!]
			product-string 		[c-string!]
			usage 				[integer!] ;usage-page and usage
			release-number		[integer!]
			interface-number	[integer!]
			next				[hid-device-info]
		]
	#import [
		LIBC-file cdecl [
			mbstowcs: "mbstowcs" [
				src 	[c-string!]
				dst 	[c-string!]
				len 	[integer!]
			]
			wcsdup: "wcsdup" [
				s1 		[c-string!]
				return: [c-string!]
			]
			udev_device_get_sysattr_value: "udev_device_get_sysattr_value" [
				dev 	[int-ptr!]
				sysattr [c-string!]
				return: [c-string!]
			]
			setlocale: "setlocale" [
				category 	[integer!]
				locale		[c-string!]
				return:		[byte-ptr!]
			]
			udev_new: "udev_new" [
				return: 	[int-ptr!]
			]
			udev_enumerate_new: "udev_enumerate_new" [
				udev		[int-ptr!]
				return: 	[int-ptr!]
			]
			udev_enumerate_add_match_subsystem: "udev_enumerate_add_match_subsystem" [
				udev_enumerate 	[int-ptr!]
				subsystem		[c-string!]
				return: 		[integer!]
			]
			udev_enumerate_scan_devices: "udev_enumerate_scan_devices" [
				udev_enumerate	[int-ptr!]
				return:			[integer!]
			]
			udev_enumerate_get_list_entry: "udev_enumerate_get_list_entry" [
				udev_enumerate 	[int-ptr!]
				return:			[int-ptr!]
			]
			udev_list_entry_get_next: "udev_list_entry_get_next" [
				list_entry		[int-ptr!]
				return: 		[int-ptr!]
			]
			udev_list_entry_get_name: "udev_list_entry_get_name" [
				list_entry		[int-ptr!]
				return:			[c-string!]
			]
			udev_device_new_from_syspath: "udev_device_new_from_syspath" [
				udev 			[int-ptr!]
				syspath 		[c-string!]
				return: 		[int-ptr!]
			]
			udev_device_get_devnode: "udev_device_get_devnode" [
				udev_device 	[int-ptr!]
				return: 		[c-string!]
			]
			udev_device_get_parent_with_subsystem_devtype: "udev_device_get_parent_with_subsystem_devtype" [
				udev_device 	[int-ptr!]
				subsystem 		[c-string!]
				devtype 		[c-string!]
				return: 		[int-ptr!]
			]
			udev_device_unref: "udev_device_unref" [
				udev_device 	[int-ptr!]
				return:			[int-ptr!]
			]
			strdup: "strdup" [
				src 		[c-string!]
				return: 	[c-string!]
			]
			strtok_r: "strtok_r" [
				s 			[c-string!]
				sep 		[c-string!]
				nextp 		[int-ptr!]
				return: 	[c-string!]
			]
			strchr: "strchr" [
				s 			[c-string!]
				n 			[integer!]
				return: 	[c-string!]
			]
			strcmp: "strcmp" [
				s1 			[c-string!]
				s2 			[c-string!]
				return: 	[integer!]
			]
			sscanf: "sscanf" [
				[variadic]
			]
			strtol: "strtol" [
				str 		[c-string!]
				endptr 		[int-ptr!]
				base 		[integer!]
				return: 	[integer!]
			]
			udev_enumerate_unref: "udev_enumerate_unref" [
				udev_enumerate 	[int-ptr!]
				return:			[int-ptr!]
			]
			udev_unref: "udev_unref" [
				udev 			[int-ptr!]
				return: 		[int-ptr!]
			]
		]
	]


	hid_device: alias struct! [
		device_handle 			[integer!]
		blocking 				[integer!]
		uses_numbered_reports	[integer!]
	]

	new_hid_device: func [
		dev 		[hid_device]
		return: 	[hid_device]
	][
		dev: as hid_device allocate size? hid_device
		dev/device_handle: -1
		dev/blocking: 1
		dev/uses_numbered_reports: 0
		dev 
	]

	utf8_to_wchar_t: func [
		utf8 		[c-string!]
		return: 	[c-string!]
		/local
			ret 	[c-string!]
			wlen 	[integer!]
			a 		[integer!]
	][
		ret: null

		if utf8 <> null [
			wlen: mbstowcs null utf8 0 
			if -1 = wlen [
				return wcsdup ""
			]
			ret: allocate (wlen + 1) * 4   ;--sizeof widechar
			mbstowcs ret utf8 (wlen + 1)
			a: wlen + 1
			ret/a: 0
		]
		ret 
	]

	;--get an atrribute value from a udev_device and return it as wchar_t
	;--string the returned string must be freed with free（） when done
	copy_udev_string: func [
		dev 		[int-ptr!] ;--udev_device
		udev_name 	[c-string!] 
		return: 	[c-string!]
	][
		utf8_to_wchar_t (udev_device_get_sysattr_value dev udev_name)	
	]

	;--uses_numered_reports return 1 if report_descriptor describes a device 
	;--which contains numbered reports
	uses_numbered_reports: func [
		report_descriptor 	[byte-ptr!]
		size				[integer!]
		return: 			[integer!]
		/local
			i 				[integer!]
			size_code 		[integer!]
			data_len 		[integer!]
			key_size		[integer!]
			key 			[integer!]
			a 				[integer!]
	][
		i: 1
		while [i < (size + 1)] [
			key: as integer! report_descriptor/i

			;--check for the report id key
			if key = 00000085h [return 1]
			
			either (key and 000000F0h) = 000000F0h [
				either (i + 1) < (size + 2) [
					a: i + 1
					data_len: report_descriptor/a 
				][
					data_len: 0
				]
				key_size: 3
			][
				size_code: key and 00000003h
				switch size_code [
					0 		[data_len: size_code]
					1 		[data_len: size_code]
					2 		[data_len: size_code]
					3 		[data_len: 4]
					default [data_len: 0]
				]
			]
			i: i + data_len + key_size	
		]
		0	
	]

	hid_init: func [
		return: 	[integer!]
		/local
			locale	[byte-ptr!]
	][
		;--set the locale if it's not set
		locale: setlocale 0 null
		if locale = null [setlocale 0 ""]
		0
	]

	parse_uevent_info: func [
		uevent 				[c-string!]
		bus_type			[int-ptr!]
		vendor_id			[int-ptr!]
		product_id			[int-ptr!]
		serial_number_utf8	[c-string!]
		product_name_utf8	[c-string!]
		return: 			[integer!]
		/local
			tmp				[c-string!]
			saveptr			[c-string!]
			line 			[c-string!]
			key 			[c-string!]
			value			[c-string!]
			found_id 		[integer!]
			found_serial	[integer!]
			found_name 		[integer!]
			ret 			[integer!]
	][
		found_id: 0 
		found_serial: 0
		found_name: 0 
		tmp: strdup uevent
		line: strtok_r tmp "\n" :saveptr
		while [line <> null] [
			;--line: "key=value"
			key: line
			value: strchr line as integer! #"="
			if value = null [
				;--goto next_line 
				line: strtok_r null "\n" :saveptr 
			]
			value/1: null-byte
			value: value + 1
			
			case [
				(strcmp key "HID_ID") = 0 [
					ret: sscanf value "%x:%hx:%hx" bus_type vendor_id product_id
					if ret = 3 [
						found_id: 1
					]	
				]
				(strcmp key "HID_NAME") = 0 [
					product_name_utf8: strdup value
					found_name: 1
				]
				(strcmp key "HID_UNIQ") = 0 [
					serial_number_utf8: strdup value
					found_serial: 1
				]
			]
			line: strtok_r null "\n" :saveptr	
		]

		free as byte-ptr! tmp 
		all [found_id found_name found_serial]
		
	]

	enumerate: func [
		vendor_id 		[integer!]
		product_id 		[integer!]
		return: 		[hid-device-info]
		/local 	
			udev 				[int-ptr!]
			enumerate 			[int-ptr!]
			devices 			[int-ptr!]
			dev_list_entry		[int-ptr!]
			root 				[hid-device-info]
			cur_dev 			[hid-device-info]
			prev_dev			[hid-device-info]
			sysfs_path			[c-string!]
			dev_path			[c-string!]
			str					[c-string!]
			raw_dev				[int-ptr!]
			hid_dev 			[int-ptr!]
			usb_dev 			[int-ptr!]
			intf_dev 			[int-ptr!]
			dev_vid				[integer!]
			dev_pid 			[integer!]
			serial_number_utf8	[c-string!]
			product_name_utf8	[c-string!]
			bus_type			[integer!]
			result				[integer!]
			tmp 				[hid-device-info]
	][
		root: null
		cur_dev: null
		prev_dev: null
		hid_init

		;--create the udev object
		udev: udev_new 
		if udev = null [
			probe "can not create udev"
			return null
		]

		;--create a list of the device in the 'hidraw' subsystem
		enumerate: udev_enumerate_new udev
		udev_enumerate_add_match_subsystem enumerate "hidraw"
		udev_enumerate_scan_devices enumerate
		devices: udev_enumerate_get_list_entry enumerate
		
		;--fir each item, see if it matchs the vid/pid and 
		;--if so create a udev_device record for it
		dev_list_entry: devices 
		while [dev_list_entry <> null] [
			;--get the filename of the /sys entry for the device 
			;--and create a udev_device object(dev) representing it
			sysfs_path: udev_list_entry_get_name dev_list_entry
			raw_dev: udev_device_new_from_syspath udev sysfs_path
			dev_path: udev_device_get_devnode raw_dev

			hid_dev: udev_device_get_parent_with_subsystem_devtype 	raw_dev
																	"hid"
																	null

			if hid_dev = null [
				;--unable to find parent hid device 
				;--go to next 
				free as byte-ptr! serial_number_utf8
				free as byte-ptr! product_name_utf8
				udev_device_unref raw_dev 
				;--go to next
			]

			result: parse_uevent_info 	(udev_device_get_sysattr_value hid_dev "uevent")
										:bus_type
										:dev_vid
										:dev_pid
										serial_number_utf8
										product_name_utf8

			if result = 0 [
				;--go to next 
				free as byte-ptr! serial_number_utf8
				free as byte-ptr! product_name_utf8
				udev_device_unref raw_dev 
				;--go to next
			]

			if all [bus_type <> 3 bus_type <> 5] [
				;--go to next 
				free as byte-ptr! serial_number_utf8
				free as byte-ptr! product_name_utf8
				udev_device_unref raw_dev 
				;--go to next
			]

			if all [any vendor_id = 0  vendor_id = dev_vid]	
			[any product_id = 0 product_id = dev_pid] [
				tmp: as hid-device-info allocate size? hid-device-info
				either cur_dev <> null [
					cur_dev/next: tmp
				][
					root: tmp
				]
				prev_dev: cur_dev
				cur_dev: tmp

				;--fill out the record 
				cur_dev/next: null
				cur_dev/path: either dev_path <> null [strdup dev_path][null]

				;--vid/pid
				cur_dev/id: dev_vid << 16 or dev_pid

				;--serial number
				cur_dev/serial-number: utf8_to_wchar_t serial_number_utf8

				;--release number
				cur_dev/release-number: 0

				;--interface number
				cur_dev/interface-number: -1

				switch bus_type [
					3 [
						usb_dev: udev_device_get_parent_with_subsystem_devtype 	raw_dev
																				"usb"
																				"usb_device"
						if usb_dev = null [
							free as byte-ptr! cur_dev/serial-number
							free as byte-ptr! cur_dev/path
							free as byte-ptr! cur_dev

							either prev_dev <> null [
								prev_dev/next: null
								cur_dev: prev_dev
							][
								root: null
								cur_dev: root
							]

							;--go to next 
							free as byte-ptr! serial_number_utf8
							free as byte-ptr! product_name_utf8
							udev_device_unref raw_dev 
							;--go to next
						]

						;--manufacturer and product strings 
						cur_dev/manufacturer-string: copy_udev_string 	usb_dev
																		device_string_names/1

						cur_dev/product-string: copy_udev_string usb_dev device_string_names/2				 

						;--release number
						str: udev_device_get_sysattr_value usb_dev "bcdDevice"
						cur_dev/release-number: either str <> null [strtol str null 16][0]

						;--get a handle to the interface's udev node
						intf_dev: udev_device_get_parent_with_subsystem_devtype	raw_dev
																				"usb"
																				"usb_interface"
						if intf_dev <> null [
							str: udev_device_get_sysattr_value intf_dev "bInterfaceNumber"
							cur_dev/interface-number: either str <> null [strtol str null 16][-1]
						]
						break
					]
					5 [
						cur_dev/manufacturer-string: wcsdup ""
						cur_dev/product-string: utf8_to_wchar_t product_name_utf8
						break
					]
					default [break]
				]
			]
			;--go to next 
			free as byte-ptr! serial_number_utf8
			free as byte-ptr! product_name_utf8
			udev_device_unref raw_dev 
			;--go to next			
			dev_list_entry: udev_list_entry_get_next
		]
		udev_enumerate_unref enumerate
		udev_unref udev 
		root 
	]

]








