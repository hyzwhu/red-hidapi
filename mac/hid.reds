Red/System []
hid: context [
	#define	EINVAL		22		;/* Invalid argument */
	#define kIOHIDSerialNumberKey               "SerialNumber"
	#define kIOHIDManufacturerKey               "Manufacturer"
	#define kIOHIDProductKey                    "Product"
	#define kIOHIDPrimaryUsagePageKey           "PrimaryUsagePage"
	#define kIOHIDPrimaryUsageKey               "PrimaryUsage"
	#define kIOHIDVersionNumberKey              "VersionNumber"
	#define kIOServicePlane						"IOService"
	#define kIOHIDVendorIDKey                   "VendorID"
	#define kIOHIDProductIDKey                  "ProductID"
	#define kIOHIDMaxInputReportSizeKey         "MaxInputReportSize"
	#define BUF_LEN 							256
	#define kCFNumberSInt32Type  				3
	#define kCFStringEncodingUTF8				08000100h
	#define CFSTR(cStr)							[CFStringCreateWithCString 0 cStr kCFStringEncodingUTF8]
	#define LOWORD(param) (param and FFFFh << 16 >> 16)   
	#define HIWORD(param) (param >> 16)
	#define WIDE_CHAR_SIZE						4
	
	
	hid_mgr: as int-ptr! 00000000h
	kCFStringEncodingUTF32LE: 1C000100h

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
	
	CFRange: alias struct! [
		location 	[integer!]
		length 		[integer!]
	]

	pthread_cond_t: alias struct! [
		__sig       [integer!]
		opaque1     [integer!]	;opaque size =24
		opaque2		[integer!]
		opaque3     [integer!]
		opaque4		[integer!]   
		opaque5     [integer!]
		opaque6		[integer!]    	       
	]
	
	pthread_barrier_t: alias struct! [
		mutex       [integer!]
		cond        [pthread_cond_t]
		count       [integer!]
		trip_count  [integer!]
	]

	io_object_t: alias struct! [
		po_SystemKey 		[integer!]
		po_MessageList 		[int-ptr!]
		po_Flags 			[integer!]
		po_Task 			[int-ptr!]
		po_openAndSignal	[integer!]	
	]

	input_report: alias struct! [
		data 		[byte-ptr!]
		len 	 	[integer!]
		next 		[input_report]
	]

	pthread_t: alias struct! [
		__sig 				[integer!]
		__cleanup_stack		[int-ptr!]
		__opaque			[byte-ptr!]
	]

	hid-device: alias struct! [
		device_handle 			[int-ptr!]
		blocking 				[integer!]
		uses_numbered_reports	[integer!]
		disconnected			[integer!]
		run_loop_mode 			[c-string!]
		run_loop 				[int-ptr!]
		source 					[int-ptr!]
		input_report_buf		[byte-ptr!]
		max_input_report_len 	[integer!]  ;CFIndex alias int
		input_reports 			[input_report]

		thread 					[pthread_t]
		mutex 					[integer!]   ;pthread_mutex_t is int
		condition 				[pthread_cond_t]
		barrier 				[pthread_barrier_t]
		shutdown_barrier 		[pthread_barrier_t]
		shutdown_thread 		[integer!]
	]

	#import [
		LIBC-file cdecl [
				strdup: "strdup" [
					str1 		[c-string!]
					return: 	[c-string!]
				]
				wcscpy: "wcscpy" [
					str1 		[c-string!]
					str2 		[c-string!]
					return: 	[c-string!]
				]
				pthread_mutex_init: "pthread_mutex_init" [
					mutex 		[int-ptr!]
					attr 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_cond_init: "pthread_cond_init" [
					cond 		[int-ptr!]
					attr 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_mutex_destroy: "pthread_mutex_destroy" [
					mutex 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_cond_destroy: "pthread_cond_destroy" [
					cond 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_mutex_lock: "pthread_mutex_lock" [
					mutex 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_mutex_unlock: "pthread_mutex_unlock" [
					mutex 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_cond_broadcast: "pthread_cond_broadcast" [
					cond 		[int-ptr!]
					return: 	[integer!]
				]
				pthread_cond_wait: "pthread_cond_wait" [
					cond		[int-ptr!]
					mutex		[int-ptr!]
					return: 	[integer!]
				]
				wcslen: "wcslen" [
					wcs   		[c-string!]
					return: 	[integer!]
				]
				wprintf: "wprintf" [
					[variadic]
					return: 	[integer!]
		]
		]
		"/System/Library/Frameworks/IOKit.framework/IOKit" cdecl [
			IOHIDDeviceGetProperty: "IOHIDDeviceGetProperty" [
				key 			[int-ptr!]
				device 			[c-string!] 
				return: 		[int-ptr!]
			]
			IOHIDDeviceGetService: "IOHIDDeviceGetService" [
				device 			[int-ptr!]
				return: 		[io_object_t]
			]
			IORegistryEntryGetPath: "IORegistryEntryGetPath" [
				entry			[io_object_t]
				plane 			[c-string!]   ;--size is 128
				path 			[c-string!]   ;--size is 512
				return: 		[integer!]
			]
			IOHIDManagerCreate: "IOHIDManagerCreate" [
				allocator 		[int-ptr!]
				options			[integer!]
				return: 		[int-ptr!]
			]
			IOHIDManagerSetDeviceMatching: "IOHIDManagerSetDeviceMatching" [
				manager 		[int-ptr!]
				matching		[int-ptr!]
			]
			IOHIDManagerScheduleWithRunLoop: "IOHIDManagerScheduleWithRunLoop" [
				manager 		[int-ptr!]
				runloop 		[int-ptr!]
				runLoopMode		[int-ptr!]
			]
			IOHIDManagerClose: "IOHIDManagerClose" [
				manager 		[int-ptr!]
				options			[integer!]
				return: 		[integer!]
			]
			IOHIDManagerCopyDevices: "IOHIDManagerCopyDevices" [
				manager			[int-ptr!]
				return: 		[int-ptr!]
			]
		]
		"/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation" cdecl [
			kCFRunLoopDefaultMode: "kCFRunLoopDefaultMode" [integer!]
			CFStringCreateWithCString: "CFStringCreateWithCString" [
						allocator	[integer!]
						cStr		[c-string!]
						encoding	[integer!]
						return:		[integer!]
					]
			CFRunLoopRunInMode: "CFRunLoopRunInMode" [
				mode 						[int-ptr!]
				seconds 					[float!]
				returnAfterSourceHandled	[logic!]
				return: 					[integer!]
			]
			CFSetGetCount: "CFSetGetCount" [
				theSet 			[int-ptr!]
				return: 		[integer!]
			]
			CFSetGetValues: "CFSetGetValues" [
				theSet 			[int-ptr!]
				values 			[int-ptr!]	
			]
			CFGetTypeID: "CFGetTypeID" [
				cf 			[int-ptr!]
				return: 	[integer!]
			]
			CFNumberGetTypeID: "CFNumberGetTypeID" [
				return: 	[integer!]
			]
			CFNumberGetValue: "CFNumberGetValue" [
				number 		[int-ptr!]
				theType 	[integer!]
				valuePtr	[int-ptr!]
				return: 	[logic!]
			]
			CFRelease: "CFRelease" [
				cf 			[int-ptr!]
			]
			CFStringGetLength: "CFStringGetLength" [
				theString 	[int-ptr!]
				return: 	[integer!]
			]
			CFStringGetBytes: "CFStringGetBytes" [
				theString					[int-ptr!]
				range 						[CFRange value]
				encoding					[integer!]
				lossByte					[byte!]
				isExternalRepresentation	[logic!]
				buffer 						[byte-ptr!]
				maxBufLen					[integer!]
				usedBufLen 					[int-ptr!]
				return: 					[integer!]
			]
			CFRunLoopGetCurrent: "CFRunLoopGetCurrent" [
				return: 				[int-ptr!]
			]

		]
	]
	
	pthread_barrier_init: func [
		barrier 	[pthread_barrier_t]
		attr 		[pthread_barrier_t]
		count 		[integer!]
		return: 	[integer!]
	][
		if count = 0 [
			return -1			
		]
		if (pthread_mutex_init :barrier/mutex null) < 0 [
			return -1
		]
		if (pthread_cond_init :barrier/cond null) < 0 [
			pthread_mutex_destroy :barrier/mutex
			return -1
		]
		barrier/trip_count: count
		barrier/count: 0
		0 
	]

	pthread_barrier_destroy: func [
		barrier 		[pthread_barrier_t]
		return: 		[integer!]
	][
		pthread_cond_destroy :barrier/cond
		pthread_mutex_destroy :barrier/mutex
		0
	]

	pthread_barrier_wait: function [
		barrier			[pthread_barrier_t]
		return: 		[integer!]
	][
		pthread_mutex_lock :barrier/mutex
		barrier/count: barrier/count + 1
		either barrier/count >= barrier/trip_count [
			barrier/count: 0
			pthread_cond_broadcast :barrier/cond
			pthread_mutex_unlock :barrier/mutex
			return 1
		][
			pthread_cond_wait :barrier/cond :barrier/mutex
			pthread_mutex_unlock :barrier/mutex
			return 0
		]
	]

	; return_data: func [   ;maybe delete
	; 	dev 		[hid-device]
	; 	data 		[byte-ptr!]
	; 	length 		[integer!]
	; 	return:  	[integer!]
	; ][]


	new-hid-device: func [
		return: 	[hid-device]
		/local
		dev 		[hid-device]
	][
		dev: as hid-device allocate size? hid-device
		dev/device_handle: null
		dev/blocking: 1
		dev/uses_numbered_reports: 0
		dev/disconnected: 0
		dev/run_loop_mode: null
		dev/run_loop: null
		dev/source: null
		dev/input_report_buf: null
		dev/input_reports: null
		dev/shutdown_thread: 0

		;allocate space for thread's opaque
		dev/thread/__opaque: allocate 596
		pthread_mutex_init :dev/mutex null
		pthread_cond_init :dev/condition null
		pthread_barrier_init as pthread_barrier_t :dev/barrier null 2
		pthread_barrier_init as pthread_barrier_t :dev/shutdown_barrier null 2
		dev
	]

	free-hid-device: func [
		dev 		[hid-device]
		/local
		rpt 		[input_report value]
		next 		[input_report]
	][
		if dev = null [
		 	exit 
		]
		;--delete any input reports still left over
		rpt: dev/input_reports
		while [rpt <> null] [
			next: rpt/next
			;free rpt/data
			;free as byte-ptr! rpt
			rpt: next
		]

		;--free the string and report buffer. 
		if dev/run_loop_mode <> null [
			CFRelease as int-ptr! dev/run_loop_mode
		]
		if dev/source <> null [
			CFRelease dev/source
		]
		;free dev/input_report_buf
		
		;--clean up the thread objects
		pthread_barrier_destroy as pthread_barrier_t :dev/shutdown_barrier
		pthread_barrier_destroy as pthread_barrier_t :dev/barrier
		pthread_cond_destroy :dev/condition
		pthread_mutex_destroy :dev/mutex

		;--free the structure itself
		free as byte-ptr! dev 
	]

	get_int_property: func [
		device 			[int-ptr!]
		key				[c-string!]
		return: 		[integer!]
		/local
			ref 		[int-ptr!]
			value 		[integer!]
	][
		value: 0
		ref: IOHIDDeviceGetProperty device key
		if ref <> null [
			if (CFGetTypeID ref) = CFNumberGetTypeID [
				CFNumberGetValue 	ref
			 	 					kCFNumberSInt32Type
				  					:value
			return value
			]
		]
		return 0
	]

	get_vendor_id: func [
		device 			[int-ptr!]
		return: 		[integer!]
	][
		return get_int_property device as c-string! CFSTR(kIOHIDVendorIDKey)
	]

	get_product_id: func [
		device 			[int-ptr!]
		return: 		[integer!]
	][
		return get_int_property device as c-string! CFSTR(kIOHIDProductIDKey)
	]

	get_max_report_length: func [
		device 			[int-ptr!]
		return: 		[integer!]
	][ 
		return get_int_property device as c-string! CFSTR(kIOHIDMaxInputReportSizeKey)
	]

	get_string_property: func [
		device 		[int-ptr!]
		prop 		[c-string!]
		buf 		[c-string!]
		len 		[integer!]
		return: 	[integer!]
		/local
			cf-str 			[int-ptr!]	
			str_len 		[integer!]
			used_buf_len	[integer!]
			chars_copied	[integer!]	
			range 			[CFRange value]
			len1 			[integer!]
	][
		used_buf_len: 0
		probe ["len:" len]
		if len = 0 [
			return 0
		]
		cf-str: IOHIDDeviceGetProperty device prop
		buf/1: null-byte
		buf/2: null-byte
		either cf-str <> null [
			str_len: CFStringGetLength cf-str
			len: len - 1
			range/location: 0
			either str_len > len [
				range/length: len 
			][
				range/length: str_len
			]
			chars_copied: CFStringGetBytes cf-str
											range
											kCFStringEncodingUTF32LE
											#"?"
											false
											as byte-ptr! buf 
											len * WIDE_CHAR_SIZE
											:used_buf_len
			either chars_copied = len [
				len1: len * 4 + 1
				buf/len1: null-byte
				len1: len + 1
				buf/len1: null-byte
			][
				len1: chars_copied * 4 + 1
				buf/len1: null-byte
				len1: len +1
				buf/len1: null-byte
			]
			return 0
		][
			return -1
		]
	]
	
	get_serial_number: func [
		device 		[int-ptr!]
		buf 		[c-string!]
		len 		[integer!]
		return: 	[integer!]
	][
		return get_string_property device (as c-string! CFSTR(kIOHIDSerialNumberKey)) buf len 
	]

	get_manufacturer_string: func [
		device 	 	[int-ptr!]
		buf 		[c-string!]
		len 		[integer!]
		return: 	[integer!]
	][		
		return get_string_property device as c-string! CFSTR(kIOHIDManufacturerKey) buf len 
	]

	get_product_string: func [
		device 		[int-ptr!]
		buf 		[c-string!]
		len 		[integer!]
	][
		probe "get_product_string"
		dump-hex as byte-ptr! buf
		get_string_property device as c-string! CFSTR(kIOHIDProductKey) buf len 
probe "after get_string_property!!!!!!!!!!!!!"
		dump-hex as byte-ptr! buf		
	]

	;--implementation of wcsdup() for mac
	dup_wcs: func [
		s 			[c-string!]
		return: 	[c-string!]
		/local
			len		[integer!]
			ret  	[c-string!]
	][
		len: wcslen s 
		ret: as c-string! allocate (len + 1) * WIDE_CHAR_SIZE
		wcscpy ret s
	]

	;--initialize the iohidmanager.return 0 for success and -1 for failure
	init_hid_manager: func [
		return: 	[integer!]
	][
		hid_mgr: IOHIDManagerCreate null 0
		if hid_mgr <> null [
			IOHIDManagerSetDeviceMatching hid_mgr null
			IOHIDManagerScheduleWithRunLoop hid_mgr CFRunLoopGetCurrent as int-ptr! kCFRunLoopDefaultMode
			return 0
		]
		return -1
	]

	;--initialize the iohidmanager if necessary. this is the public function
	hid_init: func [
		return: 	[integer!]
	][
		if hid_mgr = null [
			return init_hid_manager 
		]
		return 0
	]

	hid_exit: func [
		return: 	[integer!]
	][
		if hid_mgr <> null [
			IOHIDManagerClose hid_mgr 0
			CFRelease hid_mgr
			hid_mgr: null
		]
		0
	]
	
	process_pending_events: func [
		/local
			res  [integer!]
	][
		until [
			res: CFRunLoopRunInMode as int-ptr! kCFRunLoopDefaultMode 0.001 false
			any [res = 1  res = 3]
		]
	]


	;--hid_enumerate func
	enumerate: func [
		vendor-id	[integer!]
		product-id 	[integer!]
		return: 	[hid-device-info]
		/local 
			root 			[hid-device-info]
			cur_dev 		[hid-device-info]
			num_devices		[integer!]
			i 				[integer!]
			device_set 		[int-ptr!]
			device_array	[int-ptr!]
			dev_vid			[integer!]
			dev_pid			[integer!]
			buf 			[c-string!]
			dev 			[int-ptr!]
			tmp 			[hid-device-info]
			iokit_dev 		[io_object_t]
			res 			[integer!]  ;--kern_return_t is int
			path			[c-string!]
			x 				[integer!]
	][
		root: null
		cur_dev: null
		path: as c-string! system/stack/allocate 128
		buf: as c-string! system/stack/allocate 256
		;--set up the hid manager if it has not been done
		if hid_init < 0 [
			return null
		]
		;--give the iohidmanager a chance to updata itself
		;probe "before process pending"
		process_pending_events

		;--get a list of the devices 
		IOHIDManagerSetDeviceMatching hid_mgr null
		device_set: IOHIDManagerCopyDevices hid_mgr

		;--convert the list into a c array so we can iterate easily
		num_devices: CFSetGetCount device_set
		device_array: as int-ptr! allocate 4 * num_devices
		CFSetGetValues device_set device_array ;--typecasting (const void **)


		;--irerate over each device, making an entry for it
		i: 1
		until [
			dev: as int-ptr! device_array/i
; probe ["dev:" dev]
			if dev = null [
				continue 
			]
			dev_vid: get_vendor_id dev 
			dev_pid: get_product_id dev 
probe ["vendor_id:" dev_vid]
probe ["product_id:" dev_pid]
			;--check the vid/pid against the arguments

			if all [
				any [vendor-id = 0  vendor-id = dev_vid]
				any [product-id = 0  product-id = dev_pid] 
			][
				;--vid/pid match create the record
				tmp: as hid-device-info allocate size? hid-device-info
				either cur_dev <> null [
					cur_dev/next: tmp
				][
					root: tmp
				]
				cur_dev: tmp
			]
			
?? cur_dev
			;--get the usage page and usage for this device
			x: (get_int_property dev as c-string! CFSTR(kIOHIDPrimaryUsagePageKey)) << 16
			cur_dev/usage: cur_dev/usage and 0000FFFFh or x

			x: get_int_property dev as c-string! CFSTR(kIOHIDPrimaryUsageKey)
			cur_dev/usage: cur_dev/usage and FFFF0000h or x 

			;--fill out the record
			cur_dev/next: null

			;--fill in the path (ioservice plane)
			iokit_dev: IOHIDDeviceGetService dev
			res: IORegistryEntryGetPath iokit_dev 
										kIOServicePlane  ;--have not defined
										path

			
; probe ["cur_dev/path:" cur_dev/path]

			;--serial number
			get_serial_number dev buf BUF_LEN
;probe "buf:"
;wprintf buf
;probe " "
			cur_dev/serial-number: dup_wcs buf
probe "cur_dev/serial-number:" 
wprintf cur_dev/serial-number
probe "serial-number finished"

			;--manufacturer and product strings
			get_manufacturer_string dev buf BUF_LEN
			cur_dev/manufacturer-string: dup_wcs buf 
probe "cur_dev/manufacturer-string:"
wprintf cur_dev/manufacturer-string
probe " "
			get_product_string dev buf BUF_LEN
;dump-hex as byte-ptr! buf 
			cur_dev/product-string: dup_wcs buf 
;dump-hex as byte-ptr! cur_dev/product-string
probe "cur_dev/product-string:"
wprintf cur_dev/product-string
probe " "
probe " "
probe " "
probe " "
			;--vip/pid
			cur_dev/id: dev_pid << 16 or dev_vid
; probe "before get_int"
			;--release number 
; probe [dev " " CFSTR(kIOHIDVersionNumberKey)]
			get_int_property dev (as c-string! CFSTR(kIOHIDVersionNumberKey)) 							 
; probe "after get_int"			
			;--interface number
			cur_dev/interface-number: -1
			
			i: i + 1	
			i = (num_devices + 1)
		]

		free as byte-ptr! device_array
		CFRelease device_set

		return root
	]




]
