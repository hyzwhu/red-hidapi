Red/System []
hid: context [
	#define	EINVAL		22		;/* Invalid argument */
	#define kIOHIDSerialNumberKey               "SerialNumber"
	#define kIOHIDManufacturerKey               "Manufacturer"
	#define kIOHIDProductKey                    "Product"
	#define kIOHIDPrimaryUsagePageKey           "PrimaryUsagePage"
	#define kIOHIDPrimaryUsageKey               "PrimaryUsage"
	#define kIOHIDVersionNumberKey              "VersionNumber"
	#define BUF_LEN 							256
	#import [
		LIBC-file cdecl [

		]
		"/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation" cdecl [
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
		]
	]

	#define kCFStringEncodingUTF8		08000100h
	#define CFString(cStr)	[CFStringCreateWithCString 0 cStr kCFStringEncodingUTF8]

	kCFRunLoopDefaultMode: declare int-ptr!

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
	
	pthread_barrier_init: func [
		barrier 	[pthread_barrier_t]
		attr 		[pthread_barrier_t]
		cont 		[integer!]
		return: 	[integer!]
	][
		if count = 0 [
			return -1			
		]
		if (pthread_mutex_init :barrier/mutex 0) < 0 [
			return -1
		]
		if (pthread_cond_init :barrier/cond 0) < 0 [
			pthread_mutex_destroy :barrier/mutex
			return -1
		]
		barrier/trip_count: cont
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

	return_data: func [   ;maybe delete
		dev 		[hid-device]
		data 		[byte-ptr!]
		length 		[integer!]
		return:  	[integer!]
	][]

	input_report: alias struct! [
		data 		[byte-ptr!]
		len 	 	[integer!]
		next 		[input_report]
	]

	; darwin_pthread_handler_rec: alias struct! [
	; 	routine 	[int-ptr!]
	; 	arg 		[int-ptr!]

	; ]

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
		pthread_barrier_init :dev/barrier null 2
		pthread_barrier_init :dev/shutdown_barrier null 2
		dev
	]

	free-hid-device: func [
		dev 		[hid-device]
		/local
		rpt 		[input_report value]
		next 		[input_report]
	][
		if dev = false [
			return
		]
		;--delete any input reports still left over
		rpt: dev/input_reports
		while [rpt] [
			next: rpt/next
			free rpt/data
			free rpt
			rpt: next
		]

		;--free the string and report buffer. 
		if dev/run_loop_mode [
			CFRelease dev/run_loop_mode
		]
		if dev/source [
			CFRelease dev/source
		]
		free dev/input_report_buf
		
		;--clean up the thread objects
		pthread_barrier_destroy :dev/shutdown_barrier
		pthread_barrier_destroy :dev/barrier
		pthread_cond_destroy :dev/condition
		pthread_mutex_destroy :dev/mutex

		;--free the structure itself
		free dev 
	]

	hid_mgr: 00000000h

	get_int_property: func [
		device 			[int-ptr!]
		key				[c-string!]
		return: 		[integer!]
		/local
			ref 		[int-ptr!]
			value 		[integer!]
	][
		ref: IOHIDDeviceGetProperty device key
		if ref <> null [
			if (CFGetTypeID ref) = CFNumberGetTypeID [
				CFNumberGetValue as int-ptr! ref
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
		return get_int_property device (CFSTR kIOHIDVendorIDKey)
	]

	get_product_id: func [
		device 			[int-ptr!]
		return: 		[integer!]
	][
		return get_int_property device (CFSTR kIOHIDProductIDKey)
	]

	get_max_report_length: func [
		device 			[int-ptr!]
		return: 		[integer!]
	][ 
		return get_int_property device (CFSTR kIOHIDMaxInputReportSizeKey)
	]

	get_string_property: func [
		device 		[int-ptr!]
		prop 		[int-ptr!]
		buf 		[c-string!]
		len 		[integer!]
		return: 	[integer!]
		/local
			str 			[c-string!]	
			str_len 		[integer!]
			used_buf_len	[integer!]
			chars_copied	[integer!]	
			range 			[CFRange value]
			len1 			[integer!]
	][
		if len <> 0 [
			return 0
		]

		str: IOHIDDeviceGetProperty device prop
		buf/1: null-byte
		buf/2: null-byte
		either str <> null [
			len: len - 1

			range/location: 0
			either str_len > len [
				range/length: len 
			][
				range/length: str_len
			]

			chars_copied: CFStringGetBytes 	str
											range
											kCFStringEncodingUTF32LE
											#"?"
											false
											as byte-ptr! buf 
											len * 4
											:used_buf_len
			either chars_copied = len [
				len1: len * 2 + 1
				buf/len1: null-byte
				len1: len + 1
				buf/len1: null-byte
			][
				len1: chars_copied * 2 + 1
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
		get_string_property device (CFSTR kIOHIDSerialNumberKey) buf len 
	]

	get_manufacturer_string: func [
		device 	 	[int-ptr!]
		buf 		[c-string!]
		len 		[integer!]
		return: 	[integer!]
	][
		return get_string_property device (CFSTR kIOHIDManufacturerKey) buf len 
	]

	get_product_string: func [
		device 		[integer!]
		buf 		[c-string!]
		len 		[integer!]
		return: 	[integer!]
	][
		get_string_property device (CFSTR kIOHIDProductKey) buf len 
	]

	;--initialize the iohidmanager.return 0 for success and -1 for failure
	init_hid_manager: func [
		return: 	[integer!]
	][
		hid_mgr: IOHIDManagerCreate null 0
		if hid_mgr <> null [
			IOHIDManagerSetDeviceMatching hid_mgr null
			IOHIDManagerScheduleWithRunLoop hid_mgr CFRunLoopGetCurrent kCFRunLoopDefaultMode
			return 0
		]
		return -1
	]

	;--initialize the iohidmanager if necessary. this is the public function
	hid_init: func [
		return: 	[integer!]
	][
		if hid_mgr = 0 [
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
			res: CFRunLoopRunInMode kCFRunLoopDefaultMode 0.001 false
			all [(res <> kCFRunLoopRunFinished)  (res <> kCFRunLoopRunTimedOut)]
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
	][
		;--set up the hid manager if it has not been done
		if hid_init < 0 [
			return null
		]
		;--give the iohidmanager a chance to updata itself
		process_pending_events

		;--get a list of the devices 
		IOHIDManagerSetDeviceMatching hid_mgr null
		device_set: as int-ptr! IOHIDManagerCopyDevices hid_mgr

		;--convert the list into a c array so we can iterate easily
		num_devices: CFSetGetCount device_set
		device_array: as int-ptr! allocate 4 * num_devices
		CFSetGetValues device_set as int-ptr! device_array ;--typecasting (const void **)

		;--stack/allocate space for buf
		buf: as c-string! system/stack/allocate 128

		;--irerate over each device, making an entry for it
		i: 1
		until [
			dev: device_array/i

			if dev = null [
				continue 
			]
			dev_vid: get_vendor_id dev 
			dev_pid: get_product_id dev 

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

			;--get the usage page and usage for this device
			cur_dev/usage-page: get_int_property dev CFSTR(kIOHIDPrimaryUsagePageKey)
			cur_dev/usage: get_int_property dev CFSTR(kIOHIDPrimaryUsageKey)

			;--fill out the record
			cur_dev/next: null

			;--fill in the path (ioservice plane)
			iokit_dev: hidapi_IOHIDDeviceGetService dev
			res: IORegistryEntryGetPath iokit_dev 
										kIOServicePlane  ;--have not defined
										path
			either res = 0 [ ;--means success
				cur_dev/path: strup as byte-ptr! path
			][ ;--means failue
				cur_dev/path: strup null-byte				
			]

			;--serial number
			get_serial_number dev buf BUF_LEN
			cur_dev/serial-number: dup_wcs buf 

			;--manufacturer and product strings
			get_manufacturer_string dev buf BUF_LEN
			cur_dev/manufacturer-string: dup_wcs buf 
			get_product_string dev buf BUF_LEN
			cur_dev/product-string: dup_wcs buf 

			;--vip/pid
			cur_dev/vendor-id: dev_vid
			cur_dev/product-id: dev_pid

			;--release number 
			cur_dev/release-number: get_int_property dev CFSTR(kIOHIDVersionNumberKey) 							 
			
			;--interface number
			cur_dev/interface-number: -1
			
			i: i + 1	
			i = num_devices + 1
		]

		free as byte-ptr! device_array
		CFRelease device_set

		return root
	]




]
