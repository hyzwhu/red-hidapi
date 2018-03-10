Red/System []

windows-hidapi: context [
	#define MAX_STRING_WCHARS				00000FFFh
	#define FILE_SHARE_READ                 00000001h  
	#define FILE_SHARE_WRITE                00000002h 
	#define GENERIC_READ                    80000000h
	#define GENERIC_WRITE                   40000000h
	#define FILE_FLAG_OVERLAPPED            40000000h
	#define DIGCF_PRESENT          			00000002h
	#define DIGCF_DEVICEINTERFACE   		00000010h
	#define HIDP_STATUS_SUCCESS      		00110000h
	#define ERROR_IO_PENDING                997
	#define IOCTL_HID_GET_FEATURE			721298


	;remian a block for hidapi.h
	#define MIN(x y) (either x > y [y] [x])

	;--extract the short type data from integer!
	#define LOWORD(param) (param and FFFFh << 16 >> 16)   
	#define HIWORD(param) (param >> 16)


	;the hid header files aren't part of the sdk, we have to define
	;all this stuff here. In C'lookup_functions(). the func pointers
	;defined below are set.
	HIDD-ATTRIBUTES: alias struct! [
			Size 			[integer!]
			ID 				[integer!] ;vendorID and productID
			VersionNumber 	[integer!]
	]

	HIDP-CAPS: alias struct! [
			Usage 				[integer!] ;Usage and UsagePage
			ReportByteLength 	[integer!] ;InputReportByteLength and OutputReportByteLength
			pad1  				[integer!]
			pad2  				[integer!]
			pad3  				[integer!]
			pad4  				[integer!]
			pad5  				[integer!]
			pad6  				[integer!]
			pad7  				[integer!]
			pad8  				[integer!]
			pad9  				[integer!]
			pad10  				[integer!]
			pad11  				[integer!]
			pad12  				[integer!]
			pad13  				[integer!]
			pad14  				[integer!]
	]
	
	#import [
		"hid.dll" stdcall [
			HidD_GetAttributes: "HidD_GetAttributes" [
				device 		[int-ptr!]
				attrib 		[HIDD-ATTRIBUTES] ;have been not defined
				return: 	[logic!]
			]
			HidD_GetSerialNumberString: "HidD_GetSerialNumberString" [
				handle		[int-ptr!]
				buffer 		[byte-ptr!]
				bufferlen 	[integer!]   ;ulong
				return: 	[logic!]
			]
			HidD_GetManufacturerString: "HidD_GetManufacturerString" [
				handle		[int-ptr!]
				buffer 		[byte-ptr!]
				bufferlen 	[integer!]   ;ulong
				return: 	[logic!]
			]
			HidD_GetProductString: "HidD_GetProductString" [
				handle		[int-ptr!]
				buffer 		[byte-ptr!]
				bufferlen 	[integer!]   ;ulong
				return: 	[logic!]
			]
			HidD_SetFeature: "HidD_SetFeature" [
				handle		[int-ptr!]
				data  		[int-ptr!]
				length 		[integer!] ;ulong
				return: 	[logic!]
			]
			HidD_GetFeature: "HidD_GetFeature" [
				handle		[int-ptr!]
				data  		[int-ptr!]
				length 		[integer!] ;ulong
				return: 	[logic!]
			]
			HidD_GetIndexedString: "HidD_GetIndexedString" [
				handle			[int-ptr!]
				string-index	[integer!] ;ulong
				buffer 			[int-ptr!]
				bufferlen 		[integer!] ;ulong
				return: 		[logic!]
			]
			HidD_GetPreparsedData: "HidD_GetPreparsedData" [
				handle 			[int-ptr!]
				preparsed-data 	[int-ptr!]
				return: 		[logic!]
			]
			HidD_FreePreparsedData: "HidD_FreePreparsedData" [
				preparsed-data 	[int-ptr!]
				return: 		[logic!]
			]
			HidP_GetCaps: "HidP_GetCaps" [
				preparsed-data 	[int-ptr!]
				caps 			[HIDP-CAPS] ;need to check
				return: 		[integer!] ;ulong
			]
			HidD_SetNumInputBuffers: "HidD_SetNumInputBuffers" [
				handle			[int-ptr!]
				number-buffers 	[integer!] ;ulong
			]
		]

		"kernel32.dll" stdcall [
			CreateEvent: "CreateEventA" [
				lpEventAttributes				[integer!]
				bManualReset					[integer!]
				bInitialState					[integer!]
				lpName							[integer!]
				return:							[integer!]
			]
			CloseHandle: "CloseHandle" [
				hObject							[integer!]
				return: 						[integer!]
			]
			CreateFile: "CreateFileA" [
				lpFileName						[c-string!]
				dwDesiredAccess					[integer!]
				dwShareMode						[integer!]
				lpSecurityAttributes			[integer!]
				dwCreationDisposition			[integer!]
				dwFlagsAndAttributes			[integer!]
				hTemplateFile					[integer!]
				return:							[integer!]
			]
			LocalFree: "LocalFree" [
				hMem							[int-ptr!]
				return:							[int-ptr!]
			]
			WriteFile:	"WriteFile" [
					handle		[integer!]
					buffer		[byte-ptr!]
					bytes		[integer!]
					written		[int-ptr!]
					overlapped	[int-ptr!]
					return:		[logic!]
				]
			GetLastError: "GetLastError" [
			return:							[integer!]
				]
			ResetEvent: "ResetEvent" [
				hEvent 	[integer!]
			]
			ReadFile:	"ReadFile" [
					file		[integer!]
					buffer		[byte-ptr!]
					bytes		[integer!]
					read		[int-ptr!]
					overlapped	[int-ptr!]
					return:		[integer!]
			]
			CancelIo: "CancelIo" [
				 hFile 		[int-ptr!]	
			]
			WaitForSingleObject: "WaitForSingleObject" [
				hHandle                 [integer!]
				dwMilliseconds          [integer!]
				return:                 [integer!]
			]
			DeviceIoControl: "DeviceIoControl" [
				hDevice 		[int-ptr!]
				dwIoControlCode	[integer!]
				lpInBuffer		[byte-ptr!]
				nInBufferSize 	[integer!]
				lpOutBuffer 	[byte-ptr!]
				nOutBufferSize 	[integer!]
				lpBytesReturned [int-ptr!]
				lpOverlapped	[overlapped-struct]
				return: 		[logic!]
			]
			FormatMessage: "FormatMessageW" [
				dwFlags		 					[integer!]
				lpSource	 					[integer!]
				dwMessageId  					[integer!]
				dwLanguageId 					[integer!]
				lpBuffer	 					[c-string!]
				nSize		 					[integer!]
				Arguments	 					[integer!]
				return:		 					[integer!]
		]
			GetOverlappedResult: "GetOverlappedResult" [
				hFile							[int-ptr!]
				lpOverlapped					[overlapped-struct]
				lpNumberOfBytesTransferred		[int-ptr!]
				bWait							[logic!]
				return: 						[integer!]
			]
		]
		"setupapi.dll" stdcall [
			SetupDiGetClassDevs: "SetupDiGetClassDevsA" [
				ClassGuid						[guid-struct]
				Enumerator						[integer!]
				hwndParent						[integer!]
				Flags							[integer!]
				return: 						[integer!]
			]
			SetupDiEnumDeviceInterfaces: "SetupDiEnumDeviceInterfaces" [
				DeviceInfoSet 					[integer!]
				DeviceInfoData					[integer!]
				InterfaceClassGuid				[guid-struct]
				MemberIndex						[integer!]
				DeviceInterfaceData				[dev-interface-data]
				return: 						[logic!]
			]	
			SetupDiGetDeviceInterfaceDetail: "SetupDiGetDeviceInterfaceDetailA" [
				DeviceInfoSet 					[integer!]
				DeviceInterfaceData				[dev-interface-data]
				DeviceInterfaceDetailData		[dev-interface-detail]
				DeviceInterfaceDetailDataSize	[integer!]
				RequiredSize					[int-ptr!]
				DeviceInfoData					[dev-info-data]
				return: 						[logic!]
			]
			SetupDiDestroyDeviceInfoList: "SetupDiDestroyDeviceInfoList" [
				handle							[integer!]
				return: 						[logic!]
			]
			SetupDiEnumDeviceInfo: "SetupDiEnumDeviceInfo" [
				DeviceInfoSet 					[integer!]
				MemberIndex						[integer!]
				DeviceInfoData					[dev-info-data]
				return: 						[logic!]
			]
			SetupDiGetDeviceRegistryPropertyA: "SetupDiGetDeviceRegistryPropertyA" [
				DeviceInfoSet 					[integer!]
				DeviceInfoData 					[dev-info-data]
				Property						[integer!]
				PropertyRegDataType				[int-ptr!]
				PropertyBuffer					[c-string!]
				PropertyBufferSize				[integer!]
				RequiredSize					[int-ptr!]
				return: 						[logic!]
		]
		]
		

		LIBC-file cdecl [
			wcsdup: "_wcsdup" [
				strSource   [c-string!]
				return: 	[c-string!]
			]
			wcscmp: "wcscmp" [
				string1		[c-string!]
				string2 	[c-string!]
				return: 	[integer!]
			]
			strstr: "strstr" [
				str			[c-string!]
				substr		[c-string!]
				return:		[c-string!]
			]
			strtol: "strtol" [
				Result 		[c-string!]
				String 		[c-string!]
				return: 	[integer!]
			]
			strcmp: "strcmp" [
				Str1 		[c-string!]
				Str2 		[c-string!]
				return: 	[integer!]
			]
		]
	]

	;--define struct
	overlapped-struct: alias struct! [
		Internal	 							[integer!]
		InternalHigh 							[integer!]
		Offset		 							[integer!]
		OffsetHight  							[integer!]
		hEvent		 							[integer!]
	]
	hid-device: alias struct! [
		device-handle 			[int-ptr!]
		blocking 				[logic!]
		output-report-length 	[integer!]
		input-report-length 	[integer!]
		last-error-str 			[int-ptr!]
		last-error-num 			[integer!]
		read-pending 			[logic!]
		read-buf 				[c-string!]
		ol        				[overlapped-struct] 
	]
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
	guid-struct: alias struct! [     ;--size 16
		data1									[integer!]
		data2									[integer!]
		data3									[integer!]
		data4									[integer!]
	]
	dev-info-data: alias struct! [    ;--size: 28
		cbSize									[integer!]
		ClassGuid								[integer!]
		pad1									[integer!]
		pad2									[integer!]
		pad3									[integer!]
		DevInst									[integer!]
		reserved								[integer!]
	]	
	dev-interface-data: alias struct! [  ;--size: 28
		cbSize									[integer!]
		ClassGuid								[integer!]
		pad1									[integer!]
		pad2									[integer!]
		pad3									[integer!]
		Flags									[integer!]
		reserved								[integer!]
	]
	dev-interface-detail: alias struct! [  ;--size: 8
		cbSize									[integer!]
		DevicePath								[c-string!]
	]


	;init hid-device 
	new-hid-device: func [
		return:  	[hid-device]
	][
		dev: as hid-device allocate size? hid-device
		dev/device-handle: as int-ptr! INVALID-HANDLE-VALUE
		dev/blocking: true
		dev/output-report-length: 0
		dev/input-report-length: 0
		dev/last-error-str: null
		dev/last-error-num: 0
		dev/read-pending: 0
		dev/read-buf: null
		set-memory as byte-ptr! dev/ol as byte! 0 size? dev/ol
		dev/ol/hEvent: CreateEvent null 0 0 null
		return dev
	]

	;--free-hid-device function
	free-hid-device: func [
		dev [hid-device]
	][
		CloseHandle dev/ol/hEvent
		CloseHandle (as integer! dev/device-handle)
		LocalFree 	 dev/last-error-str
		free as byte! dev/read-buf
		free as byte! dev
	]

	;--register_error
	register-error: func [
		device 		[hid-device]
		op 			[c-string!]
		/local
			ptr 	[c-string!]
			msg 	[c-string!]
	][
		FormatMessage 4864 null GetLastError 1024 msg 0 null
		;--get rid of the CR and LF that FormatMessage() sticks at the
	   	;--end of the message.
		ptr: msg 
		while ptr/1 <> null-byte [
			if ptr/1 = #"\r" [
				ptr/1: null-byte
				break
			]
			ptr: ptr + 1
		]
		;------
		LocalFree device/last-error-str
		device/last-error-str: as int-ptr! msg ;--maybe a fault 

	]

	;--static handle open_device func
	open-device: func [
		path 		[c-string!]
		enumerate 	[logic!]
		return: 	[int-ptr!]
		/local 
			handle 			[int-ptr!]
			desired-access 	[integer!]
			share-mode		[integer!]
	][
		handle: declare int-ptr!
		either enumerate [
			desired-access: 0
		][
			desired-access: GENERIC_WRITE or GENERIC_READ
		]
		share-mode: FILE_SHARE_READ or FILE_SHARE_WRITE
		handle: as int-ptr! (CreateFile path desired-access 
		share-mode null 3 FILE_FLAG_OVERLAPPED 0)
		return handle
	]

	;--hid_enumerate function
	hid-enumerate: func [
		id 		[integer!] ;vendor-id and product-id
		return: [hid-device-info]
		/local 
			res 				[logic!]
			root				[hid-device-info]
			cur-dev 			[hid-device-info]
			devinfo-data 		[dev-info-data value]
			devinterface-data 	[dev-interface-data value]
			devinterface-detail	[dev-interface-detail value] 
			device-info-set		[int-ptr!]
			InterfaceClassGuid  [guid-struct value]
			device-index		[integer!]
			i					[integer!]
			write-handle 		[int-ptr!]
			required-size 		[integer!]
			attrib 				[HIDD-ATTRIBUTES]
			str 				[c-string!]
			tmp 				[hid-device-info]
			pp-data 			[int-ptr!]
			caps 				[HIDP-CAPS value]
			res1				[logic!]
			nt-res				[integer!]
			wstr				[int-ptr!]
			len 				[integer!]
			b 					[int-ptr!]
			interface-component [c-string!]
			endptr 				[c-string!]
			hex-str				[c-string!]
			driver_name 		[c-string!]
	][	
		
		root: as hid-device-info allocate size? hid-device-info
		cur-dev: as hid-device-info allocate size? hid-device-info
		;-- allocate mem for devinfo
		root: null
		cur-dev: null
		devinterface-detail: null
		;--Windows objects for interacting with the driver.
		;init InterfaceClassGuid
		InterfaceClassGuid/data1: 4D1E55B2h
		InterfaceClassGuid/data2: 11CFF16Fh
		InterfaceClassGuid/data3: 1100CB88h
		InterfaceClassGuid/data4: 30000011h
		;-----------
		device-info-set: as int-ptr! INVALID-HANDLE-VALUE
		device-index: 0

		;--Initialize the Windows objects.
		set-memory as byte-ptr! devinfo-data null-byte size? devinfo-data
		devinfo-data/cbSize: size? dev-info-data
		devinterface-data/cbSize: size? dev-interface-data

		;--information for all the devices belonging to the HID class.
		device-info-set: as int-ptr! SetupDiGetClassDevs InterfaceClassGuid null null 
		(DIGCF_PRESENT or DIGCF_DEVICEINTERFACE)
		
		;--Iterate over each device in the HID class, looking for the right one.
		forever [
			write-handle: as int-ptr! INVALID-HANDLE-VALUE
			required-size: 0
			attrib: as HIDD-ATTRIBUTES allocate 1
			res: SetupDiEnumDeviceInterfaces (as integer! device-info-set) 
			null InterfaceClassGuid device-index devinterface-data
			if res = false [
				;-- A return of FALSE from this function means that there are no more devices.
				break
			]
			
			res: SetupDiGetDeviceInterfaceDetail as integer! device-info-set 
			devinterface-data null 0 :required-size null
			
			devinterface-detail: as dev-interface-detail allocate required-size
			devinterface-detail/cbSize: size? dev-interface-detail
			;--Get the detailed data for this device.
			res: SetupDiGetDeviceInterfaceDetail as integer! device-info-set 
			devinterface-data devinterface-detail required-size null null

			if res = false [
				free as byte-ptr! devinterface-detail
				device-index: device-index + 1
			]

			;--Make sure this device is of Setup Class "HIDClass" and has a driver bound to it.
			i: 0
			forever [
				driver_name: as byte-ptr! system/stack/allocate 256
				res: SetupDiEnumDeviceInfo (as integer! SetupDiEnumDeviceInfo)
				i devinfo-data
				if res = false [
					free as byte-ptr! devinterface-detail
					device-index: device-index + 1	
				]

				res: SetupDiGetDeviceRegistryPropertyA (as integer! device-info-set)
				devinfo-data 7 null driver_name (size? driver_name) null
				if res = false [
					free as byte-ptr! devinterface-detail
					device-index: device-index + 1	
				]

				if (strcmp driver_name "HIDClass") = 0 [
					res: SetupDiGetDeviceRegistryPropertyA (as integer! device-info-set)
					devinfo-data 9 null driver_name (size? driver_name) null
					if res [
						break
					]
				]
				i: i + 1
			]

			;------------------------
			
			;--open a handle to the device 
			write-handle: open-device devinterface-detail/DevicePath true
			
			;--check validity of write-handle
			if write-handle = (as int-ptr! INVALID-HANDLE-VALUE) [
				CloseHandle (as integer! write-handle)
			]

			;--Get the Vendor ID and Product ID for this device.
			attrib/Size: size? HIDD-ATTRIBUTES
			HidD_GetAttributes write-handle attrib

			if (id = 0) or (attrib/ID = id) [
				pp-data: null
				caps: as HIDP-CAPS system/stack/allocate 1
				wstr: as int-ptr! system/stack/allocate 1024
				tmp: as hid-device-info system/stack/allocate size? hid-device-info
				;--vid/pid match . create the record
				either as logic! cur-dev [
					cur-dev/next: tmp
				][
					root: tmp
				]
				cur-dev: tmp

				;--Get the Usage Page and Usage for this device.
				res1: HidD_GetPreparsedData write-handle pp-data
				if res1 [
					nt-res: HidP_GetCaps pp-data caps
					if nt-res = 00110000h [
						cur-dev/usage: caps/Usage
					]
					HidD_FreePreparsedData pp-data

				]

				;--fill out the record
				cur-dev/next: null
				str: devinterface-detail/DevicePath
				either as logic! (as integer! str) [
					;len: length? str
					cur-dev/path: str
					
				][
					cur-dev/path: null
					
				]

				;--define wstr 
				;wstr: as int-ptr! system/stack/allocate 1024
    			b: wstr + 255
				;--serial number
				res1: HidD_GetSerialNumberString write-handle wstr size? wstr
				b/value: b/value and 0000FFFFh or (00000000h << 16)
				if res1 [
					cur-dev/serial-number: wcsdup wstr
				]
				;--manufacturer string
				res1: HidD_GetManufacturerString: write-handle wstr size? wstr
				b/value: b/value and 0000FFFFh or (00000000h << 16)
				if res1 [
					cur-dev/manufacturer-string: wcsdup wstr
				]
				;-------

				;--product string
				res1: HidD_GetProductString write-handle wstr size? wstr
				b/value: b/value and 0000FFFFh or (00000000h << 16)
				if res1 [
					cur-dev/product-string : wcsdup wstr
				]

				;--------

				;--vid/pid
				cur-dev/id: attrib/ID

				;--release Number
				cur-dev/release-number: attrib/VersionNumber
				

				;--Interface Number.
				cur-dev/interface-number: -1
				if as logic! (as integer! cur-dev/path) [
					interface-component: declare c-string!
					interface-component: strstr cur-dev "&mi_"
					if as logic! (as integer! interface-component)[
					hex-str: declare c-string!
					endptr: declare c-string!
					hex-str: interface-component + 4
					endptr: null
					cur-dev/interface-numberL strtol hex-str endptr/1 16 ;have some problems
					if endptr = hex-str [
						cur-dev/interface-number: -1
					]
					]
				]
			]
		]
		;close the device information handle
		SetupDiDestroyDeviceInfoList: as integer! device-info-set	
		return root
	]

	hid-open: func [
		id 				[integer!] ;vid and pid
		serial-number	[c-string!]
		return:			[hid-device]
		/local
		devs 			[hid-device-info value]
		cur-dev			[hid-device-info value]
		path-to-open	[c-string!]
		handle 			[hid-device value]
		tmp				[integer!]
	][
		path-to-open: null
		handle: null

		devs: hid-enumerate id
		cur-dev: devs 
		while [cur-dev <> null] [
			if cur-dev/id = id [
				either as logic! serial-number [
					tmp: wcscmp serial-number cur-dev/serial-number
					if tmp = 0 [
						path-to-open: cur-dev/path
						break
					]
				][
					path-to-open: cur-dev/path
					break
				]
			]
			cur-dev: cur-dev/next
		]

		if as logic! path-to-open [
			;--open the device 
			handle: hid-open-path path-to-open ;--have not been defined
		]

		hid-free-enumeration devs  ;--have not been defined

		return handle
		
	]

	hid-open-path: func [
		path 		[c-string!]
		return  	[hid-device]
		/local
			dev 	[hid-device]
			caps	[HIDP-CAPS]
			pp-data	[int-ptr!]
			res 	[logic!]
			nt-res 	[integer!]
			buf 	[byte-ptr!]
	][
		pp-data: null
		
		if hid-init < 0 [ ;--have not been defined yet
			return null
		]

		dev: new-hid-device

		;--open a handle to the device 
		dev/device-handle: open-device path false

		;--check validity of write-handle
		if (as integer! dev/device-handle) = INVALID-HANDLE-VALUE [
			;--unabele to open the device 
			register-error dev "CreateFile"  ;--have not been defined yet
			free-hid-device dev 
			return null
		]

		;--set the input report buffer size to 64 reports
		res: HidD_SetNumInputBuffers dev/device-handle 64
		if res = false [
			register-error dev "HidD_SetNumInputBuffers"
			free-hid-device dev 
			return null
		]

		;--get the input report length for the device 
		res: HidD_GetPreparsedData dev/device-handle pp-data
		if res = false [
			register-error dev  "HidD_GetPreparsedData"
			free-hid-device dev 
			return null
		]

		nt-res: HidP_GetCaps pp-data caps
		if (nt-res xor HIDP_STATUS_SUCCESS) <> 0[
			register-error dev "HidP_GetCaps"
			HidD_FreePreparsedData pp-data
		]
		dev/output-report-length: LOWORD(caps/ReportByteLength)
		dev/input-report-length: HIWORD(caps/ReportByteLength)
		HidD_FreePreparsedData pp-data
		dev/read-buf: as byte-ptr! allocate dev/input-report-length
		return dev 


	]

	hid-write: func [
		dev 	[hid-device]
		data 	[byte-ptr!]
		length 	[integer!]
		return: [integer!]
		/local 
			bytes-written	[integer!]
			res  			[logic!]
			ol 				[overlapped-struct value]
			buf 			[byte-ptr!]

	][
		set-memory as byte-ptr! ol (as byte! 0) (size? ol)	
		either length >= dev/output-report-length [
			buf: data 
		][
			buf: as byte-ptr! system/stack/allocate dev/output-report-length
			copy-memory buf data length
			set-memory (buf + length) (as byte! 0) (dev/output-report-length - length)
			length: dev/output-report-length
		]
		res: WriteFile dev/device-handle buf  length null (as int-ptr! ol)

		if res = false [
			if GetLastError <> ERROR_IO_PENDING [
				register-error dev "WriteFile"
				bytes-written: -1
				if buf <> data [
					free as byte-ptr! buf 
				]
			]
		]

		;--Wait here until the write is done.
		res: GetOverlappedResult dev/device-handle ol :bytes-written true
		if res = false [
			register-error dev  "WriteFile"
			bytes-written: -1
			if buf <> data [
					free as byte-ptr! buf 
				]
		]
		return bytes-written
	]

	hid-read-timeout: func [
		dev				[hid-device]
		data 			[byte-ptr!]
		length 			[integer!]
		milliseconds	[integer!]
		return: 		[integer!]
		/local 
			bytes-read	[integer!]
			copy-len	[integer!]
			res 		[logic!]
			ev 			[integer!] ;---handle
	][
		bytes-read: 0
		copy-len: 	0
		
		;--copy the handle for convenience
		ev: dev/ol/hEvent
		if dev/read-pending = false [
			;--start an overlapped i/o read
			dev/read-pending: true
			set-memory dev/read-buf (as byte! 0) dev/input-report-length
			ResetEvent ev 
			res: ReadFile (as integer! dev/device-handle) dev/read-buf dev/input-report-length :bytes-read (as int-ptr! dev/ol)

			if res = false [
				if GetLastError <> ERROR_IO_PENDING [
					;--ReadFile() has failed. Clean up and return error.
					CancelIo dev/device-handle
					dev/read-pending: false
					if res = false [
						register-error dev "GetOverlappedResult"
						return -1
					]
				]
			]
		]
			if milliseconds >= 0 [
				;--see if there is any data yet
				res: as logic! (WaitForSingleObject ev milliseconds)
				if res = true [
					;--there was no data this time.return zero bytes available
					return 0
				]
			]

			res: GetOverlappedResult dev/device-handle dev/ol :bytes-read true
			

			;--set pending back to false
			dev/read-pending: false

			if res and (bytes-read/value > 0) [
				either dev/read-buf/value = 0 [
					bytes-read: bytes-read - 1
					either length > bytes-read [
						copy-len: bytes-read

					][
						copy-len: length
					]
				][
					;--copy the whole buffer ,report number and all
					either length > bytes-read [
						copy-len: bytes-read

					][
						copy-len: length
					]
					copy-memory data dev/read-buf copy-len
				]
			]
			return copy-len
		]

		hid-read: func [
			dev 	[hid-device]
			data 	[byte-ptr!]
			length	[integer!]
			return: [integer!]
			/local
				a 	[integer!]
		][
			either dev/blocking = true [
				a: -1 
			][
				a: 0
			]
			return hid-read-timeout dev data length a 
		]

		hid-set-nonblocking: func [
			dev 		[hid-device]
			nonblock 	[integer!]
			return: 	[integer!]
			/local 
				a 		[logic!]
		][
			either nonblock <> 0  [
				a: false 
			][
				a: true
			]
			dev/blocking: a 
			return 0			
		]

		hid-send-feature-report: func [
			dev 	[hid-device]
			data 	[byte-ptr!]
			length	[integer!]
			return: [integer!]	
			/local
				res [logic!]
		][
			res: HidD_SetFeature dev/device-handle (as int-ptr! data) length
			if res = false [
				register-error dev "HidD_SetFeature"
				return -1
			]
			return length
		]

		hid-get-feature-report: func [
			dev 		[hid-device]
			data 		[byte-ptr!]
			length		[integer!]
			return: 	[integer!]
			/local
				res 			[logic!]
				bytes-returned	[integer!]
				ol				[overlapped-struct value]
		][
			set-memory  (as byte-ptr! ol) (as byte! 0) (size? ol)
			res: DeviceIoControl dev/device-handle IOCTL_HID_GET_FEATURE
			data length data length :bytes-returned ol

			if res = false [
				if GetLastError <> ERROR_IO_PENDING [
					;--deviceiocontrol failed. return error
					register-error dev "Send Feature Report DeviceIoControl"
					return -1
				]
			]

			;--wait here until the write is done. this makes hid-get-feature-report() synchronous.
			res: GetOverlappedResult dev/device-handle ol 
			:bytes-returned true
			if res = false [
				;--the operation failed
				register-error dev 	"Send Feature Report GetOverLappedResult"
				return -1
			]

			;--bytes_returned does not include the first byte which contains the
	  		;--report ID. The data buffer actually contains one more byte than
	  		;--bytes_returned.

			bytes-returned: bytes-returned + 1
			return bytes-returned
		]

		hid-close: func [
			dev 	[hid-device]
		][
			if dev = null [
				return 
			]
			CancelIo dev/device
			free-hid-device dev
		]

		hid-get-manufacturer-string: func [
			dev 	[hid-device]
			string 	[byte-ptr!]
			maxlen 	[integer!]
			return:	[integer!]
			/local 
				res [logic!]

		][
			res: HidD_GetManufacturerString dev/device-handle string 
			((size? byte-ptr!) * MIN(maxlen MAX_STRING_WCHARS))
			if res = false [
				register-error dev "HidD_GetManufacturerString"
				return -1
			]
			return 0	
		]

		hid-get-product-string: func [
			dev 	[hid-device]
			string 	[byte-ptr!]
			maxlen 	[integer!]
			return:	[integer!]
			/local 
				res [logic!]

		][
			res: HidD_GetProductString dev/device-handle string 
			((size? byte-ptr!) * MIN(maxlen MAX_STRING_WCHARS))
			if res = false [
				register-error dev "HidD_GetProductString"
				return -1
			]
			return 0	
		]

		hid-get-serialnumber-string: func [
			dev 	[hid-device]
			string 	[byte-ptr!]
			maxlen 	[integer!]
			return:	[integer!]
			/local 
				res [logic!]

		][
			res: HidD_GetSerialNumberString dev/device-handle string 
			((size? byte-ptr!) * MIN(maxlen MAX_STRING_WCHARS))
			if res = false [
				register-error dev "HidD_GetSerialNumberString"
				return -1
			]
			return 0	
		]

		hid-get-indexed-string: func [
			dev 	[hid-device]
			string 	[int-ptr!]
			maxlen 	[integer!]
			return:	[integer!]
			/local 
				res [logic!]

		][
			res: HidD_GetIndexedString dev/device-handle string 
			((size? byte-ptr!) * MIN(maxlen MAX_STRING_WCHARS))
			if res = false [
				register-error dev "HidD_GetIndexedString"
				return -1
			]
			return 0	
		]

		hid-error: func [
			dev 	[hid-device]
			/local
				return: [int-ptr!]
		][
			return dev/last-error-str
		]
]






		
		








	

